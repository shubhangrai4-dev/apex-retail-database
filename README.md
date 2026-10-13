# Apex Retail Database Architecture & Analytics

A Database Management Systems (DBMS) Course Project  
**Course:** CS301 - Principles of Database Systems & Analytics  
**Authors:** Student Project Group (Department of Computer Science & Engineering)  

---

## 1. Project Overview

For our database systems semester project, we chose to analyze the **Apex Retail Enterprise Data**, a production-scale e-commerce database comprising over 100,000 anonymized real-world transactional records spanning 2016 through 2018. 

As an enterprise marketplace, Apex Retail operates across multiple geographical nodes, facilitating interactions between distributed buyers, independent sellers, logistics carriers, and diverse product categories. The sheer scale and heterogeneity of the transaction logs presented significant data engineering and modeling challenges. 

Our core objective in this project is twofold:
1. Examine, validate, and clean the multi-table relational database schema used in transactional processing (OLTP).
2. Design and implement an automated Extract, Transform, and Load (ETL) pipeline using relational algebra operations (joins, projections, filtering, and aggregations) to construct a high-performance Online Analytical Processing (OLAP) star/denormalized schema. The denormalized analytical mart is persisted in columnar Parquet format and visualized through an interactive Streamlit executive dashboard.

---

## 2. Database Architecture & ER Modeling

When we first inspected the raw database dumps provided in `data/raw/`, we realized the transactional engine was heavily normalized into distinct entity tables to support high-throughput ACID transactions. The relational model originally decoupled each domain concern into separate relation schemas:

- **Customers Entity (`apex_customers`):** Contains customer surrogate identifiers (`customer_id`), unique identity hashes (`customer_unique_id`), and geographical attributes (zip code prefix, city, state).
- **Orders Entity (`apex_orders`):** Acts as the central event ledger, storing primary keys (`order_id`), customer foreign keys (`customer_id`), order status flags (`delivered`, `shipped`, `canceled`), and multiple lifecycle timestamps (purchase, approval, carrier pickup, customer delivery, estimated delivery).
- **Order Items Entity (`apex_order_items`):** A composite-key associative entity (`order_id`, `order_item_id`) that links individual physical items to sellers and products, tracking individual item prices and freight values.
- **Products Entity (`apex_products`):** Contains product primary keys (`product_id`), category classifications, dimension measurements, and physical specifications.
- **Order Payments Entity (`apex_order_payments`):** Tracks payment methods (credit card, voucher, boleto, debit), sequential installments, and monetary payment allocations per order.
- **Category Translations Entity (`product_category_name_translation`):** A dimensional lookup dictionary mapping localized category terms to standardized English categories.

### The Normalization Trade-Off
While having the data scattered across these six normalized relations prevented update anomalies during operational order entry, attempting direct analytical reporting across millions of row combinations resulted in expensive real-time join bottlenecks. To solve this for our analytical dashboard, we engineered an OLAP pipeline that joins these normalized relations into a consolidated master analytics dataset (`apex_master_dataset.parquet`).

---

## 3. Core DBMS Concepts Applied

In building our ETL pipeline and analytics application, we put core theoretical database principles into practical implementation:

- **Referential Integrity (Primary & Foreign Keys):**  
  We enforced relational mapping integrity across all tables. We verified that every child record in `apex_order_items` and `apex_order_payments` possessed a valid foreign key referencing a parent record in `apex_orders`. Similarly, `customer_id` was verified against `apex_customers` to ensure no orphan orders or ghost buyers existed. In cases where payment splits produced multi-row installments, we aggregated payments to preserve 1:1 and 1:N cardinality relationships without duplicating item-level costs.

- **Data Normalization (3NF):**  
  We analyzed the raw transactional schema and observed that it adheres strictly to Third Normal Form (3NF). Non-key attributes are fully functionally dependent on primary keys (eliminating partial dependencies / 2NF violations), and transitive dependencies are decoupled (e.g., product specifications are separated from individual order line items, and customer locations are separated from order fulfillment logs). Recognizing 3NF helped us understand the initial relational structure before deliberately denormalizing for OLAP reporting.

- **Complex Joins (Relational Algebra):**  
  To transform the 3NF tables into an analytical data mart, our pipeline implemented a sequence of relational algebra operators:
  $$\Pi_{\text{attributes}} \left( \sigma_{\text{valid}} (\text{Orders} \bowtie_{\text{order\_id}} \text{Items} \bowtie_{\text{customer\_id}} \text{Customers} \bowtie_{\text{product\_id}} \text{Products} \bowtie_{\text{order\_id}} \text{Payments}) \right)$$
  We executed sequential `INNER JOIN` operations for essential entity intersections (orders with valid items and customer references) and `LEFT OUTER JOIN` operations for dimensional enrichment (product category translations and payment summaries) so no valid order records were inadvertently dropped.

- **Data Cleaning & Constraints (DDL/DML Simulation):**  
  Because raw CSV files do not have native database schema enforcement, our Python pipeline acted as a database constraint engine:
  - *Domain Constraints & Type Casting:* We cast string timestamp representations into structured SQL-like datetime domains (`order_purchase_timestamp`, `order_delivered_customer_date`, etc.).
  - *Not-Null Constraints:* We dropped records missing mandatory operational keys or delivery timestamps required for delay computation.
  - *Check Constraints & Outlier Filtering:* We filtered out negative monetary values and extreme freight charges (values beyond the 99.9th percentile) that represented data entry corruptions or delivery anomalies.

---

## 4. Directory Structure

```text
apex_retail_analytics/
│
├── .streamlit/
│   └── config.toml                # Corporate UI styling & custom color palette
│
├── data/
│   ├── raw/                       # Staging directory for normalized raw CSV tables
│   └── processed/                 # Optimized Parquet analytical data mart
│
├── src/
│   ├── download_data.py           # Automated data acquisition & Kaggle API handler
│   └── etl_pipeline.py            # Relational join engine, cleaning, & RFM calculation
│
├── app/
│   └── dashboard.py               # Streamlit multi-tab executive BI interface
│
├── requirements.txt               # Python package dependencies
└── README.md                      # Project documentation and database analysis report
```

---

## 5. Setup & Execution Instructions

### Prerequisites
Make sure Python 3.9+ is installed on your machine.

### Installation
1. Open your terminal and change into the project directory:
   ```bash
   cd apex_retail_analytics
   ```

2. Install all required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Download the raw enterprise dataset:
   ```bash
   python src/download_data.py
   ```
   *(Note: Ensure your `kaggle.json` credentials are configured in `~/.kaggle/kaggle.json`. If unconfigured, the script will notify you and prepare benchmark enterprise staging data.)*

4. Run the ETL pipeline to process, clean, join, and compute analytical segments:
   ```bash
   python src/etl_pipeline.py
   ```

5. Launch the Streamlit analytical dashboard:
   ```bash
   streamlit run app/dashboard.py
   ```

---

## 6. Dashboard Modules & Analytics Breakdown

1. **Executive KPI Dashboard:**  
   Aggregates transaction totals, compute gross revenue, average order value (AOV), and temporal revenue trajectories using monthly and weekly time-series plots. Includes database architectural context explaining denormalized aggregation across payments and orders.
2. **Logistics & Supply Chain:**  
   Evaluates carrier performance by computing fulfillment latency and the delivery delay metric:
   $$\text{delivery\_delay\_days} = \text{delivered\_customer\_date} - \text{estimated\_delivery\_date}$$
   Presents delay distribution histograms highlighting positive delay skews and regional logistics bottlenecks.
3. **Product Performance:**  
   Analyzes category sales volume, revenue contribution, and freight-to-price ratios by leveraging order item and product dimension joins.
4. **Customer Retention (RFM Analysis):**  
   Implements an analytical RFM (Recency, Frequency, Monetary) segmentation model using SQL-equivalent window functions and quantile aggregation, grouping customers into actionable business cohorts (Champions, Loyal Customers, At Risk, Hibernating, etc.).
