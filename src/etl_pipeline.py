"""
ETL Pipeline for Apex Retail Enterprise Analytics
Transforms normalized relational tables into an optimized OLAP analytical Parquet dataset.
"""

import sys
import os
from pathlib import Path
import numpy as np
import pandas as pd


def get_project_root() -> Path:
    """Return the absolute path of the project root directory."""
    return Path(__file__).resolve().parent.parent


def find_file(raw_dir: Path, primary_name: str, fallback_name: str) -> Path:
    """Helper to locate primary apex-named file or fallback file."""
    p1 = raw_dir / primary_name
    if p1.exists():
        return p1
    p2 = raw_dir / fallback_name
    if p2.exists():
        return p2
    # Search by keyword
    keyword = primary_name.replace("apex_", "").replace("_dataset.csv", "")
    for f in raw_dir.glob("*.csv"):
        if keyword in f.name:
            return f
    raise FileNotFoundError(f"Could not locate table '{primary_name}' or '{fallback_name}' in {raw_dir}")


def run_etl():
    """
    Executes the end-to-end ETL workflow:
    1. Extract: Loads raw CSV tables.
    2. Transform:
       - Merges relational entities (Orders, Items, Customers, Products, Payments).
       - Cleans missing values and enforces data types.
       - Filters extreme freight outliers.
       - Computes delivery delay metrics.
       - Calculates RFM customer segmentation.
    3. Load: Persists the denormalized dataset as columnar Parquet.
    """
    project_root = get_project_root()
    raw_dir = project_root / "data" / "raw"
    processed_dir = project_root / "data" / "processed"
    processed_dir.mkdir(parents=True, exist_ok=True)
    output_parquet = processed_dir / "apex_master_dataset.parquet"

    print("=" * 70)
    print("🚀 APEX RETAIL ENTERPRISE ETL PIPELINE INITIATED")
    print("=" * 70)

    # ---------------------------------------------------------
    # STAGE 1: EXTRACT
    # ---------------------------------------------------------
    print("\n[ETL - 1/6] Extracting raw normalized tables from storage...")
    orders_path = find_file(raw_dir, "apex_orders_dataset.csv", "olist_orders_dataset.csv")
    items_path = find_file(raw_dir, "apex_order_items_dataset.csv", "olist_order_items_dataset.csv")
    customers_path = find_file(raw_dir, "apex_customers_dataset.csv", "olist_customers_dataset.csv")
    products_path = find_file(raw_dir, "apex_products_dataset.csv", "olist_products_dataset.csv")
    payments_path = find_file(raw_dir, "apex_order_payments_dataset.csv", "olist_order_payments_dataset.csv")

    translation_path = raw_dir / "product_category_name_translation.csv"

    print(f"  -> Reading orders from: {orders_path.name}")
    df_orders = pd.read_csv(orders_path)
    print(f"     Raw orders loaded: {len(df_orders):,} records")

    print(f"  -> Reading order items from: {items_path.name}")
    df_items = pd.read_csv(items_path)
    print(f"     Raw items loaded: {len(df_items):,} records")

    print(f"  -> Reading customers from: {customers_path.name}")
    df_customers = pd.read_csv(customers_path)
    print(f"     Raw customers loaded: {len(df_customers):,} records")

    print(f"  -> Reading products from: {products_path.name}")
    df_products = pd.read_csv(products_path)
    print(f"     Raw products loaded: {len(df_products):,} records")

    print(f"  -> Reading payments from: {payments_path.name}")
    df_payments = pd.read_csv(payments_path)
    print(f"     Raw payments loaded: {len(df_payments):,} records")

    df_trans = None
    if translation_path.exists():
        print(f"  -> Reading category translations from: {translation_path.name}")
        df_trans = pd.read_csv(translation_path)

    # ---------------------------------------------------------
    # STAGE 2: RELATIONAL ALGEBRA JOINS
    # ---------------------------------------------------------
    print("\n[ETL - 2/6] Executing sequential relational joins & denormalization...")

    # Payment Aggregation (1:1 per order to avoid row multiplication)
    print("  -> Aggregating multi-installment payments per order key...")
    payments_agg = df_payments.groupby("order_id").agg(
        total_payment_value=("payment_value", "sum"),
        primary_payment_type=("payment_type", lambda x: x.mode()[0] if not x.empty else "other"),
        max_installments=("payment_installments", "max"),
        payment_splits_count=("payment_sequential", "count"),
    ).reset_index()

    # Join 1: Orders (Fact base) INNER JOIN Items (Line items) on order_id
    print("  -> Merging Orders ⨝ Order Items on 'order_id'...")
    master = pd.merge(df_orders, df_items, on="order_id", how="inner")
    print(f"     Post items join: {len(master):,} rows")

    # Join 2: Merge Customers on customer_id
    print("  -> Merging Master ⨝ Customers on 'customer_id'...")
    master = pd.merge(master, df_customers, on="customer_id", how="inner")
    print(f"     Post customers join: {len(master):,} rows")

    # Join 3: Merge Products on product_id
    print("  -> Merging Master ⟕ Products on 'product_id'...")
    master = pd.merge(master, df_products, on="product_id", how="left")

    # Join 4: Merge Category Translation
    if df_trans is not None and "product_category_name" in master.columns:
        print("  -> Merging Category Translations on 'product_category_name'...")
        master = pd.merge(master, df_trans, on="product_category_name", how="left")
        master["category"] = master["product_category_name_english"].fillna(master["product_category_name"]).fillna("other")
        master["category"] = master["category"].astype(str).str.replace("_", " ").str.title()
    else:
        master["category"] = master.get("product_category_name", "Uncategorized").fillna("Uncategorized").astype(str).str.title()

    # Join 5: Merge Payment Aggregates on order_id
    print("  -> Merging Master ⟕ Payments Summary on 'order_id'...")
    master = pd.merge(master, payments_agg, on="order_id", how="left")
    master["total_payment_value"] = master["total_payment_value"].fillna(master["price"] + master["freight_value"])
    master["primary_payment_type"] = master["primary_payment_type"].fillna("unknown")

    # ---------------------------------------------------------
    # STAGE 3: DATA CLEANING & CONSTRAINT ENFORCEMENT
    # ---------------------------------------------------------
    print("\n[ETL - 3/6] Enforcing integrity constraints and type casting...")
    initial_count = len(master)

    # Cast timestamp columns
    timestamp_cols = [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ]
    for col in timestamp_cols:
        if col in master.columns:
            master[col] = pd.to_datetime(master[col], errors="coerce")

    # Filter critical nulls: Valid purchase timestamp and price required
    master = master.dropna(subset=["order_purchase_timestamp", "price", "order_id", "customer_unique_id"])
    
    # Filter monetary anomalies: positive prices only
    master = master[master["price"] > 0]

    # Filter freight anomalies: remove extreme freight outliers (> 99.9th percentile)
    freight_upper_bound = master["freight_value"].quantile(0.999)
    print(f"  -> Outlier Detection: Filtering freight charges above ${freight_upper_bound:.2f} (99.9th percentile)")
    master = master[(master["freight_value"] >= 0) & (master["freight_value"] <= freight_upper_bound)]

    # Compute Line Item Total
    master["line_item_total"] = (master["price"] + master["freight_value"]).round(2)

    rows_dropped = initial_count - len(master)
    print(f"  -> Constraints applied: Dropped {rows_dropped:,} anomalous rows ({len(master):,} retained).")

    # ---------------------------------------------------------
    # STAGE 4: SUPPLY CHAIN & LOGISTICS METRICS
    # ---------------------------------------------------------
    print("\n[ETL - 4/6] Computing delivery delay metrics & supply chain KPIs...")

    # Delivery Delay (Days): Actual Delivered Date - Estimated Delivery Date
    # Positive = Delivered late (delay), Negative = Delivered ahead of schedule
    master["delivery_delay_days"] = (
        master["order_delivered_customer_date"] - master["order_estimated_delivery_date"]
    ).dt.total_seconds() / (24 * 3600)
    master["delivery_delay_days"] = master["delivery_delay_days"].round(2)

    # Fulfillment Cycle Time (Days): Order Purchase Date to Delivered Date
    master["fulfillment_duration_days"] = (
        master["order_delivered_customer_date"] - master["order_purchase_timestamp"]
    ).dt.total_seconds() / (24 * 3600)
    master["fulfillment_duration_days"] = master["fulfillment_duration_days"].round(2)

    # Flag late orders
    master["is_delayed"] = master["delivery_delay_days"] > 0

    # Extract temporal dimensions for analytics
    master["purchase_year"] = master["order_purchase_timestamp"].dt.year
    master["purchase_month"] = master["order_purchase_timestamp"].dt.strftime("%Y-%m")
    master["purchase_date"] = master["order_purchase_timestamp"].dt.date
    master["purchase_day_name"] = master["order_purchase_timestamp"].dt.day_name()
    master["purchase_hour"] = master["order_purchase_timestamp"].dt.hour

    # ---------------------------------------------------------
    # STAGE 5: RFM (RECENCY, FREQUENCY, MONETARY) SEGMENTATION
    # ---------------------------------------------------------
    print("\n[ETL - 5/6] Computing customer RFM segmentation model...")

    # Reference date for recency calculation: 1 day past max transaction date
    ref_date = master["order_purchase_timestamp"].max() + pd.Timedelta(days=1)
    print(f"  -> Analytical reference date: {ref_date.strftime('%Y-%m-%d')}")

    # Group by unique customer key
    rfm = master.groupby("customer_unique_id").agg(
        recency_days=("order_purchase_timestamp", lambda x: (ref_date - x.max()).days),
        frequency=("order_id", "nunique"),
        monetary_value=("line_item_total", "sum"),
    ).reset_index()

    # Assign R, F, M quantile scores (1 to 4)
    # Recency: lower days is better -> reverse bins (4 is highest recency score)
    rfm["r_score"] = pd.qcut(rfm["recency_days"], q=4, labels=[4, 3, 2, 1]).astype(int)

    # Frequency: Most customers have 1 purchase in typical marketplace data
    # Create robust score based on purchase count
    def score_frequency(f):
        if f >= 3:
            return 4
        elif f == 2:
            return 3
        else:
            return 1

    rfm["f_score"] = rfm["frequency"].apply(score_frequency)

    # Monetary: higher spend is better
    rfm["m_score"] = pd.qcut(rfm["monetary_value"].rank(method="first"), q=4, labels=[1, 2, 3, 4]).astype(int)

    # Segmentation Logic
    def assign_rfm_segment(row):
        r, f, m = row["r_score"], row["f_score"], row["m_score"]
        if r >= 3 and f >= 3 and m >= 3:
            return "Champions"
        elif f >= 3 or (r >= 3 and m >= 3):
            return "Loyal Customers"
        elif r >= 3 and f == 1 and m >= 2:
            return "Potential Loyalists"
        elif r <= 2 and (f >= 3 or m >= 3):
            return "At Risk"
        elif r <= 2 and m >= 2:
            return "Hibernating"
        else:
            return "Lost Customers"

    rfm["rfm_segment"] = rfm.apply(assign_rfm_segment, axis=1)

    print("  -> RFM Segment distribution across customer base:")
    seg_counts = rfm["rfm_segment"].value_counts()
    for seg, count in seg_counts.items():
        print(f"     - {seg:20s}: {count:,} customers ({count/len(rfm)*100:.1f}%)")

    # Merge RFM metrics back into Master dataset
    master = pd.merge(
        master,
        rfm[["customer_unique_id", "recency_days", "frequency", "monetary_value", "rfm_segment"]],
        on="customer_unique_id",
        how="left",
    )

    # ---------------------------------------------------------
    # STAGE 6: PERSISTENCE (PARQUET)
    # ---------------------------------------------------------
    print("\n[ETL - 6/6] Persisting master dataset into Parquet format...")
    # Clean types for optimal Parquet serialization
    for col in master.select_dtypes(include="object").columns:
        master[col] = master[col].astype(str)

    master.to_parquet(output_parquet, index=False, engine="pyarrow", compression="snappy")
    file_size_mb = output_parquet.stat().st_size / (1024 * 1024)

    print("=" * 70)
    print("✅ ETL PIPELINE COMPLETED SUCCESSFULLY!")
    print(f"   Target Parquet: {output_parquet}")
    print(f"   Total Records Processed: {len(master):,}")
    print(f"   Total Attributes: {len(master.columns)}")
    print(f"   Output File Size: {file_size_mb:.2f} MB")
    print("=" * 70)


if __name__ == "__main__":
    run_etl()
