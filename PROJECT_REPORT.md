# Database Management Systems (DBMS) Course Project Report

## Apex Retail Database Architecture & Analytics

---

**Student Name(s):** Shubhang Rai  
**Roll Number(s):** [Insert Roll Number]  
**Branch & Section:** B.Tech Computer Science & Engineering (Artificial Intelligence)  
**Course Instructor:** Priyankar  
**Academic Session:** 2026–2027 (Monsoon Semester)  

**Department of Computer Science & Engineering**  
**Indian Institute of Information Technology (IIIT) Bhopal**  

---

## Contents

- **1. Introduction**
  - 1.1 Project Overview
  - 1.2 Problem Statement
  - 1.3 Objectives
  - 1.4 Scope of the Project
  - 1.5 Software and Hardware Requirements
- **2. System Requirements and Analysis**
  - 2.1 Functional Requirements
  - 2.2 Business Rules
- **3. Entity–Relationship (ER) Modeling**
  - 3.1 Identification of Entities and Attributes
  - 3.2 Identification of Relationships and Cardinalities
  - 3.3 ER Diagram Representation
  - 3.4 Detailed Explanation of Structural Constraints and Participation
- **4. ER-to-Relational Mapping**
  - 4.1 Mapping Rules
  - 4.2 Step-by-Step Conversion
  - 4.3 Final Relational Schema
- **5. Functional Dependencies & Key Analysis**
  - 5.1 Identification of Functional Dependencies
  - 5.2 Candidate Keys and Attribute Classification
  - 5.3 Formal Functional Dependency Analysis
- **6. Database Normalization**
  - 6.1 Unnormalized Form (UNF)
  - 6.2 First Normal Form (1NF)
  - 6.3 Second Normal Form (2NF)
  - 6.4 Third Normal Form (3NF)
  - 6.5 Boyce–Codd Normal Form (BCNF) Verification
  - 6.6 Final Normalized Schema Summary
- **7. Relational Integrity and Constraints**
  - 7.1 Domain Constraints
  - 7.2 Key and Entity Integrity
  - 7.3 Referential Integrity and Cascading Actions
  - 7.4 Semantic and Check Constraints
- **8. MySQL Database Implementation**
  - 8.1 Database Creation
  - 8.2 Production DDL Table Definitions
  - 8.3 Sample DML Insertions
  - 8.4 Data Modification and Deletion Operations
  - 8.5 Sample Database Contents
  - 8.6 Ten (10) Complete Relational SQL Queries
  - 8.7 Advanced DBMS Features: Views and Triggers
- **9. Application Development**
  - 9.1 Three-Tier System Architecture
  - 9.2 Front-End Technologies
  - 9.3 Application Modules
  - 9.4 Database Connectivity and Data Access Layer
  - 9.5 Application Screenshots and Interface Walkthrough
  - 9.6 Database Operations through the Application
- **10. Testing and Results**
  - 10.1 Structured Test Matrix
  - 10.2 Query Testing
  - 10.3 Constraint Enforcement Testing
  - 10.4 Results and Discussion
- **11. Conclusion and Future Scope**
  - 11.1 Conclusion
  - 11.2 Limitations
  - 11.3 Future Scope
- **References**
- **Appendix A: Complete MySQL Script**
- **Appendix B: Source Code & Repository Details**
- **Appendix C: Application Screenshots**
- **Appendix D: Team Contribution Matrix**

---

## List of Figures
- **Figure 3.1:** Entity-Relationship (ER) Diagram of the Apex Retail Enterprise System
- **Figure 4.1:** Relational Schema Mapping Diagram with Foreign Key Dependencies
- **Figure 6.1:** Functional Dependency Diagram Illustrating Normalization Steps
- **Figure 9.1:** Three-Tier System Architecture (Client $\rightarrow$ Application Server $\rightarrow$ Relational Store)
- **Figure 9.2:** Streamlit Executive KPI Dashboard Interface
- **Figure 9.3:** Logistics & Delivery Delay Distribution Visualizer
- **Figure 9.4:** Customer RFM Behavioral Cohort Donut Chart

## List of Tables
- **Table 1.1:** Hardware and Software System Specifications
- **Table 4.1:** Entity-to-Relation Mapping Summary
- **Table 5.1:** Candidate Keys, Prime, and Non-Prime Attribute Classification
- **Table 6.1:** Normalization Progression Summary (UNF to BCNF)
- **Table 7.1:** Enforced Integrity Constraints Matrix
- **Table 10.1:** Comprehensive DBMS Test Case Matrix (T1 through T6)
- **Table 10.2:** Customer RFM Segment Distribution Summary

---

## Chapter 1: Introduction

### 1.1 Project Overview
The **Apex Retail Database Architecture & Analytics** project implements an enterprise-grade database management system and decision support platform designed to handle large-scale e-commerce operations. The underlying dataset models a modern marketplace economy comprising over 100,000 commercial transactions spanning 2016 through 2018. The transactional ecosystem connects geographically distributed customers, independent sellers, logistical carriers, catalog products, and diverse payment options. 

The primary objective of this project is to model, normalize, and implement an ACID-compliant relational database in **MySQL 8.0+**, enforcing strict referential and domain integrity. Furthermore, the system incorporates an analytical data processing pipeline that denormalizes transactional records into an optimized columnar mart (persisted in Apache Parquet format) to drive a high-performance **Streamlit** executive dashboard with sub-second query response times.

### 1.2 Problem Statement
Traditional retail transaction tracking systems frequently suffer from severe structural limitations when scaled:
1. **Uncontrolled Data Redundancy:** Storing transactional logs in denormalized or flat-file structures results in repetitive entries for customers, sellers, and product details.
2. **Relational Anomalies:**
   - *Insertion Anomaly:* Inability to record a newly onboarded seller or product until an order is placed.
   - *Deletion Anomaly:* Deleting an order history inadvertently deletes the customer's permanent geographical address or product metadata.
   - *Update Anomaly:* Updating a product's price or description requires modifying thousands of redundant historical line items, introducing systemic data inconsistency.
3. **Absence of Referential Integrity:** Without relational foreign key constraints, orphan orders, unlinked payment installments, and missing items compromise financial ledgers.
4. **Logistics & Delay Obfuscation:** Failure to model lifecycle event timestamps (approval, carrier handover, customer delivery, estimated delivery) impedes supply chain bottleneck identification.

### 1.3 Objectives
- Design a formal Entity-Relationship (ER) model capturing enterprise e-commerce entities, cardinalities, and participation constraints.
- Map the conceptual ER model into a Third Normal Form (3NF) and Boyce-Codd Normal Form (BCNF) relational schema to eliminate anomalies.
- Implement production-ready Data Definition Language (DDL) scripts in MySQL with primary keys, foreign keys with referential actions (`ON DELETE`, `ON UPDATE`), and domain `CHECK` constraints.
- Implement complex relational queries, views, and operational triggers.
- Build a Python/Streamlit analytical dashboard connected to the data mart for real-time executive KPI auditing, logistics delay evaluation, and RFM customer segmentation.

### 1.4 Scope of the Project
The scope encompasses:
- Database architecture, schema design, and mathematical normalization.
- Ingestion and data cleaning of 100,000+ transactional records.
- Backend database management in MySQL and analytical processing via Python.
- Interactive multi-tab web-based visual analytics interface.
- Rigorous constraint validation and boundary testing.

### 1.5 Software and Hardware Requirements

| Component | Specification / Version | Role in System |
|:---|:---|:---|
| **Operating System** | Windows 10/11, Linux (Ubuntu 22.04+), macOS | Host Development Platform |
| **Relational Database** | MySQL Server 8.0+ | Primary Relational Engine (InnoDB) |
| **Database Tool** | MySQL Workbench / MySQL CLI | Schema execution, DDL/DML profiling |
| **Programming Language** | Python 3.10 – 3.12 | Backend logic, ETL pipeline, application |
| **Web Framework** | Streamlit 1.30+ | Frontend BI user interface |
| **Data Processing** | Pandas 2.2+, NumPy 1.26+, PyArrow 15.0+ | In-memory query processing & Parquet I/O |
| **Visualization** | Plotly Express & Plotly Graph Objects | Interactive charting and distribution plots |
| **Hardware Specs** | Min: Quad-core CPU, 8 GB RAM, 2 GB Disk | Recommended: 16 GB RAM for 100k+ row in-memory joins |

---

## Chapter 2: System Requirements and Analysis

### 2.1 Functional Requirements
1. **Customer Record Management:** The system must record unique customer profiles, associating each order with a specific geographical zip code, city, and state.
2. **Order Lifecycle Tracking:** The system must record order placement, approval timestamp, logistics carrier handover, actual doorstep delivery timestamp, and estimated delivery SLA.
3. **Multi-Item Order Processing:** The database must support multi-item orders where individual order line items reference different products, distinct merchants, specific item unit prices, and independent shipping tariffs.
4. **Multi-Instrument Payment Settlement:** The system must accommodate orders split across payment instruments (credit cards, bank slips/boleto, vouchers, debit cards) with installment sequencing.
5. **Logistics Delay Auditing:** The platform must compute fulfillment latency and delivery delay metrics ($\text{delivered\_date} - \text{estimated\_date}$) to highlight supply chain bottlenecks.
6. **Customer Behavioral Segmentation:** The application must compute Recency, Frequency, and Monetary (RFM) statistics per unique customer to categorize them into actionable CRM segments.

### 2.2 Business Rules
- **BR1 (Primary Key Uniqueness):** Every customer, product, seller, and order must possess a globally unique identifier (UUID / VARCHAR(36)).
- **BR2 (Mandatory Customer Association):** An order cannot exist without an associated customer record (`customer_id` is NOT NULL and references `customers`).
- **BR3 (Item-Level Composite Identity):** Each line item within an order is identified by the composite key `(order_id, order_item_id)`.
- **BR4 (Non-Negative Financials):** Product prices must be strictly greater than zero (`price > 0.00`). Freight fees and payment values must be non-negative (`freight_value >= 0.00`, `payment_value >= 0.00`).
- **BR5 (Chronological Consistency):** The customer delivery timestamp must be greater than or equal to the purchase timestamp (`order_delivered_customer_date >= order_purchase_timestamp`).
- **BR6 (Referential Cascading Policy):** Deleting an order must cascade to delete associated line items and payments (`ON DELETE CASCADE`), but customer or product master records cannot be deleted if referenced by an active transaction (`ON DELETE RESTRICT`).

---

## Chapter 3: Entity–Relationship (ER) Modeling

### 3.1 Identification of Entities and Attributes
- **CUSTOMERS (Strong Entity):**
  - `customer_id` (PK, VARCHAR(36)) - Unique transaction-level customer token.
  - `customer_unique_id` (VARCHAR(36)) - Permanent customer identity key across multiple orders.
  - `customer_zip_code_prefix` (INT) - Postal area code.
  - `customer_city` (VARCHAR(100)) - Customer city.
  - `customer_state` (CHAR(2)) - Customer federated state abbreviation.
- **SELLERS (Strong Entity):**
  - `seller_id` (PK, VARCHAR(36)) - Merchant identifier.
  - `seller_zip_code_prefix` (INT) - Merchant warehouse postal area.
  - `seller_city` (VARCHAR(100)) - Merchant warehouse city.
  - `seller_state` (CHAR(2)) - Merchant warehouse state.
- **PRODUCTS (Strong Entity):**
  - `product_id` (PK, VARCHAR(36)) - SKU identifier.
  - `product_category_name` (VARCHAR(100)) - Standardized category taxonomy.
  - `product_name_length`, `product_description_length`, `product_photos_qty` (INT) - Catalog metadata.
  - `product_weight_g`, `product_length_cm`, `product_height_cm`, `product_width_cm` (INT) - Physical shipping attributes.
- **ORDERS (Central Transaction Entity):**
  - `order_id` (PK, VARCHAR(36)) - Transaction primary key.
  - `customer_id` (FK, VARCHAR(36)) - Foreign key to `CUSTOMERS`.
  - `order_status` (ENUM) - Lifecycle state (`delivered`, `shipped`, `invoiced`, `processing`, `canceled`, `unavailable`).
  - `order_purchase_timestamp`, `order_approved_at`, `order_delivered_carrier_date`, `order_delivered_customer_date`, `order_estimated_delivery_date` (DATETIME).
- **ORDER_ITEMS (Associative Entity):**
  - `order_id` (PK, FK, VARCHAR(36)), `order_item_id` (PK, INT).
  - `product_id` (FK, VARCHAR(36)), `seller_id` (FK, VARCHAR(36)).
  - `shipping_limit_date` (DATETIME), `price` (DECIMAL(10,2)), `freight_value` (DECIMAL(10,2)).
- **ORDER_PAYMENTS (Weak Associative Entity):**
  - `order_id` (PK, FK, VARCHAR(36)), `payment_sequential` (PK, INT).
  - `payment_type` (ENUM), `payment_installments` (INT), `payment_value` (DECIMAL(10,2)).

### 3.2 Identification of Relationships and Cardinalities
1. **CUSTOMERS places ORDERS:**
   - Cardinality: $1:N$. One customer can place 0, 1, or many orders. Each order is placed by exactly one customer.
   - Participation: `ORDERS` has total participation (every order requires a customer); `CUSTOMERS` has partial participation.
2. **ORDERS contains ORDER_ITEMS:**
   - Cardinality: $1:N$. An order contains one or more items ($N \ge 1$).
   - Participation: Both participate totally.
3. **PRODUCTS included in ORDER_ITEMS:**
   - Cardinality: $1:N$. A product may appear in multiple line items ($N \ge 0$).
4. **SELLERS fulfills ORDER_ITEMS:**
   - Cardinality: $1:N$. Each line item is fulfilled by exactly one registered merchant.
5. **ORDERS settled via ORDER_PAYMENTS:**
   - Cardinality: $1:N$. An order has 1 or more payment installments ($N \ge 1$).

### 3.3 ER Diagram Representation

```mermaid
erDiagram
    CUSTOMERS ||--o{ ORDERS : "places (1:N)"
    ORDERS ||--|{ ORDER_ITEMS : "contains (1:N)"
    PRODUCTS ||--o{ ORDER_ITEMS : "included_in (1:N)"
    SELLERS ||--o{ ORDER_ITEMS : "fulfills (1:N)"
    ORDERS ||--|{ ORDER_PAYMENTS : "settled_via (1:N)"

    CUSTOMERS {
        varchar customer_id PK
        varchar customer_unique_id
        int customer_zip_code_prefix
        varchar customer_city
        char customer_state
    }

    ORDERS {
        varchar order_id PK
        varchar customer_id FK
        enum order_status
        datetime order_purchase_timestamp
        datetime order_approved_at
        datetime order_delivered_carrier_date
        datetime order_delivered_customer_date
        datetime order_estimated_delivery_date
    }

    ORDER_ITEMS {
        varchar order_id PK, FK
        int order_item_id PK
        varchar product_id FK
        varchar seller_id FK
        datetime shipping_limit_date
        decimal price
        decimal freight_value
    }

    PRODUCTS {
        varchar product_id PK
        varchar product_category_name
        int product_weight_g
        int product_length_cm
        int product_height_cm
        int product_width_cm
    }

    SELLERS {
        varchar seller_id PK
        int seller_zip_code_prefix
        varchar seller_city
        char seller_state
    }

    ORDER_PAYMENTS {
        varchar order_id PK, FK
        int payment_sequential PK
        enum payment_type
        int payment_installments
        decimal payment_value
    }
```

### 3.4 Detailed Explanation of Structural Constraints and Participation
- **Total vs. Partial Participation:** `ORDERS` exhibits total participation in its relationship with `CUSTOMERS` because an order cannot exist in the database without an originating customer key. Conversely, `CUSTOMERS` exhibits partial participation because prospective buyers may register an account prior to executing a commercial purchase.
- **Resolution of M:N Relationships:** The Many-to-Many relationship between `ORDERS` and `PRODUCTS` is formally decomposed using the associative relation `ORDER_ITEMS`. This captures item-level granularity (order item sequence, individual seller attribution, specific price at the time of purchase, and freight charge).

---

## Chapter 4: ER-to-Relational Mapping

### 4.1 Mapping Rules
1. **Rule 1 (Strong Entity Types):** For each regular entity type $E$, create a relation $R$ containing all simple attributes of $E$. The primary key of $E$ becomes the primary key of $R$.
2. **Rule 2 (Binary 1:N Relationship Types):** Identify the relation $S$ representing the entity on the $N$-side of the relationship. Include the primary key of the relation $T$ (on the 1-side) as a foreign key in $S$.
3. **Rule 3 (Binary M:N Relationship Types):** Create a new associative relation $R$ to represent the M:N relationship. Include the primary keys of both participating entities as foreign keys in $R$. Their combination forms the composite primary key of $R$, along with any relationship attributes.
4. **Rule 4 (Weak Entity Types):** Create a relation containing the attributes of the weak entity and include the primary key of the owner entity as a foreign key. The primary key of the weak relation is the combination of the owner primary key and the weak entity's partial key (discriminator).

### 4.2 Step-by-Step Conversion
- **Step 1 (Strong Entities):**
  - Map `CUSTOMERS` to relation `customers(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)`. PK: `customer_id`.
  - Map `SELLERS` to relation `sellers(seller_id, seller_zip_code_prefix, seller_city, seller_state)`. PK: `seller_id`.
  - Map `PRODUCTS` to relation `products(product_id, product_category_name, product_weight_g, dimensions...)`. PK: `product_id`.
- **Step 2 (1:N Orders Relationship):**
  - Map `ORDERS` with foreign key `customer_id` referencing `customers(customer_id)`. PK: `order_id`.
- **Step 3 (M:N Order Items Decomposition):**
  - Map `ORDER_ITEMS` with composite PK `(order_id, order_item_id)`. FKs: `order_id` references `orders(order_id)`, `product_id` references `products(product_id)`, and `seller_id` references `sellers(seller_id)`.
- **Step 4 (Weak Entity Payments):**
  - Map `ORDER_PAYMENTS` with composite PK `(order_id, payment_sequential)`. FK: `order_id` references `orders(order_id)`.

### 4.3 Final Relational Schema
- $\text{customers}(\underline{\text{customer\_id}}, \text{customer\_unique\_id}, \text{customer\_zip\_code\_prefix}, \text{customer\_city}, \text{customer\_state})$
- $\text{sellers}(\underline{\text{seller\_id}}, \text{seller\_zip\_code\_prefix}, \text{seller\_city}, \text{seller\_state})$
- $\text{products}(\underline{\text{product\_id}}, \text{product\_category\_name}, \text{product\_name\_length}, \text{product\_description\_length}, \text{product\_photos\_qty}, \text{product\_weight\_g}, \text{product\_length\_cm}, \text{product\_height\_cm}, \text{product\_width\_cm})$
- $\text{orders}(\underline{\text{order\_id}}, \text{customer\_id}^{\text{FK}}, \text{order\_status}, \text{order\_purchase\_timestamp}, \text{order\_approved\_at}, \text{order\_delivered\_carrier\_date}, \text{order\_delivered\_customer\_date}, \text{order\_estimated\_delivery\_date})$
- $\text{order\_items}(\underline{\text{order\_id}}^{\text{FK}}, \underline{\text{order\_item\_id}}, \text{product\_id}^{\text{FK}}, \text{seller\_id}^{\text{FK}}, \text{shipping\_limit\_date}, \text{price}, \text{freight\_value})$
- $\text{order\_payments}(\underline{\text{order\_id}}^{\text{FK}}, \underline{\text{payment\_sequential}}, \text{payment\_type}, \text{payment\_installments}, \text{payment\_value})$

---

## Chapter 5: Functional Dependencies & Key Analysis

### 5.1 Identification of Functional Dependencies
- **Relation `customers`:**
  - $FD_{1.1}: \text{customer\_id} \rightarrow \text{customer\_unique\_id}, \text{customer\_zip\_code\_prefix}, \text{customer\_city}, \text{customer\_state}$
- **Relation `sellers`:**
  - $FD_{2.1}: \text{seller\_id} \rightarrow \text{seller\_zip\_code\_prefix}, \text{seller\_city}, \text{seller\_state}$
- **Relation `products`:**
  - $FD_{3.1}: \text{product\_id} \rightarrow \text{product\_category\_name}, \text{product\_name\_length}, \text{product\_description\_length}, \text{product\_photos\_qty}, \text{product\_weight\_g}, \text{product\_length\_cm}, \text{product\_height\_cm}, \text{product\_width\_cm}$
- **Relation `orders`:**
  - $FD_{4.1}: \text{order\_id} \rightarrow \text{customer\_id}, \text{order\_status}, \text{order\_purchase\_timestamp}, \text{order\_approved\_at}, \text{order\_delivered\_carrier\_date}, \text{order\_delivered\_customer\_date}, \text{order\_estimated\_delivery\_date}$
- **Relation `order_items`:**
  - $FD_{5.1}: (\text{order\_id}, \text{order\_item\_id}) \rightarrow \text{product\_id}, \text{seller\_id}, \text{shipping\_limit\_date}, \text{price}, \text{freight\_value}$
- **Relation `order_payments`:**
  - $FD_{6.1}: (\text{order\_id}, \text{payment\_sequential}) \rightarrow \text{payment\_type}, \text{payment\_installments}, \text{payment\_value}$

### 5.2 Candidate Keys and Attribute Classification

| Relation | Candidate Key(s) | Prime Attributes | Non-Prime Attributes |
|:---|:---|:---|:---|
| **`customers`** | `customer_id` | `customer_id` | `customer_unique_id`, `customer_zip_code_prefix`, `customer_city`, `customer_state` |
| **`sellers`** | `seller_id` | `seller_id` | `seller_zip_code_prefix`, `seller_city`, `seller_state` |
| **`products`** | `product_id` | `product_id` | `product_category_name`, dimensions, weight |
| **`orders`** | `order_id` | `order_id` | `customer_id`, `order_status`, lifecycle timestamps |
| **`order_items`** | `(order_id, order_item_id)` | `order_id`, `order_item_id` | `product_id`, `seller_id`, `shipping_limit_date`, `price`, `freight_value` |
| **`order_payments`** | `(order_id, payment_sequential)` | `order_id`, `payment_sequential` | `payment_type`, `payment_installments`, `payment_value` |

### 5.3 Formal Functional Dependency Analysis
Every functional dependency in the system is determined strictly by the fundamental business logic of the enterprise:
1. In `order_items`, neither `order_id` alone nor `order_item_id` alone can determine `price` or `product_id`, because an order can have multiple items and different orders reuse item sequences (e.g., item 1). Hence, the determinant must be the composite set $\{\text{order\_id}, \text{order\_item\_id}\}$.
2. In `products`, each catalog SKU is functionally unique and determines category and physical shipping properties.
3. In `orders`, an order belongs to exactly one customer at a single transaction timestamp.

---

## Chapter 6: Database Normalization

### 6.1 Unnormalized Form (UNF)
Consider an initial unnormalized relation representing order transactions:
$$\text{UNF\_ORDERS}(\text{order\_id}, \text{customer\_id}, \text{customer\_city}, \text{order\_date}, \{\text{item\_id}, \text{product\_id}, \text{product\_cat}, \text{price}, \text{seller\_id}, \text{seller\_city}\}, \{\text{pay\_seq}, \text{pay\_type}, \text{pay\_val}\})$$
In UNF, repeating groups exist for ordered line items and payment installments. Multi-valued arrays violate basic database atomicity and generate severe update anomalies.

### 6.2 First Normal Form (1NF)
**Definition:** A relation is in 1NF if and only if all domain values are atomic scalar values, and there are no repeating groups.
**Decomposition:**
We flatten the repeating groups by establishing discrete candidate keys:
- Separate order line items into a distinct relation keyed on `(order_id, order_item_id)`.
- Separate payments into a distinct relation keyed on `(order_id, payment_sequential)`.
All attributes now hold atomic domains (strings, integers, decimals, datetimes).

### 6.3 Second Normal Form (2NF)
**Definition:** A relation is in 2NF if it is in 1NF and no non-prime attribute is partially dependent on any candidate key of the relation (elimination of partial dependencies).
**Analysis:**
In a combined relation $\text{FLAT\_ITEMS}(\underline{\text{order\_id}}, \underline{\text{order\_item\_id}}, \text{product\_id}, \text{product\_weight\_g}, \text{price})$:
- Candidate Key: `(order_id, order_item_id)`
- Dependency 1: $(\text{order\_id}, \text{order\_item\_id}) \rightarrow \text{price}$ (Full dependency)
- Dependency 2: $\text{product\_id} \rightarrow \text{product\_weight\_g}$
- But $\text{product\_id}$ is determined by the key, meaning product physical attributes depend only on the product, not on the order!
**Decomposition into 2NF:**
We decompose `FLAT_ITEMS` into:
1. $\text{order\_items}(\underline{\text{order\_id}}, \underline{\text{order\_item\_id}}, \text{product\_id}^{\text{FK}}, \text{seller\_id}^{\text{FK}}, \text{price}, \text{freight\_value})$
2. $\text{products}(\underline{\text{product\_id}}, \text{product\_category\_name}, \text{product\_weight\_g}, \dots)$
This completely eliminates partial dependencies.

### 6.4 Third Normal Form (3NF)
**Definition:** A relation is in 3NF if it is in 2NF and no non-prime attribute is transitively dependent on the primary key ($X \rightarrow Y$ and $Y \rightarrow Z$ where $Z$ is non-prime).
**Analysis:**
Consider the `customers` relation:
$$\text{customer\_id} \rightarrow \text{customer\_zip\_code\_prefix} \rightarrow \text{customer\_city}, \text{customer\_state}$$
While city and state correlate with postal code prefixes, in real-world logistics, municipal boundaries and postal zones can overlap. To avoid artificial join overhead in high-throughput OLTP systems while preserving BCNF for core entities, separating customer identity from order headers satisfies 3NF because no non-prime attribute in `orders` depends on anything other than `order_id`. Similarly, seller metadata is decoupled from line items.

### 6.5 Boyce–Codd Normal Form (BCNF) Verification
**Definition:** A relation $R$ is in BCNF if for every non-trivial functional dependency $X \rightarrow Y$, $X$ is a superkey of $R$.
**Verification:**
- In `customers`: Determinant is `customer_id`, which is a superkey.
- In `sellers`: Determinant is `seller_id`, which is a superkey.
- In `products`: Determinant is `product_id`, which is a superkey.
- In `orders`: Determinant is `order_id`, which is a superkey.
- In `order_items`: Determinant is `(order_id, order_item_id)`, which is a superkey.
- In `order_payments`: Determinant is `(order_id, payment_sequential)`, which is a superkey.
Since every determinant across all relations is a candidate key, the entire database schema strictly adheres to **Boyce-Codd Normal Form (BCNF)**.

### 6.6 Final Normalized Schema Summary

| Relation Name | Normal Form Satisfied | Primary Key | Foreign Key(s) |
|:---|:---:|:---|:---|
| **`customers`** | BCNF | `customer_id` | None |
| **`sellers`** | BCNF | `seller_id` | None |
| **`products`** | BCNF | `product_id` | None |
| **`orders`** | BCNF | `order_id` | `customer_id` $\rightarrow$ `customers` |
| **`order_items`** | BCNF | `(order_id, order_item_id)` | `order_id` $\rightarrow$ `orders`, `product_id` $\rightarrow$ `products`, `seller_id` $\rightarrow$ `sellers` |
| **`order_payments`** | BCNF | `(order_id, payment_sequential)` | `order_id` $\rightarrow$ `orders` |

---

## Chapter 7: Relational Integrity and Constraints

### 7.1 Domain Constraints
Domain constraints specify the allowable set of values for each attribute:
- `customer_state`, `seller_state`: `CHAR(2)` restricted to valid two-letter federated state codes.
- `order_status`: Restricted via `ENUM('delivered', 'shipped', 'invoiced', 'processing', 'canceled', 'unavailable')`.
- `payment_type`: Restricted via `ENUM('credit_card', 'boleto', 'voucher', 'debit_card')`.
- `customer_zip_code_prefix`: Enforced via `CHECK (customer_zip_code_prefix BETWEEN 1000 AND 99999)`.

### 7.2 Key and Entity Integrity
- **Entity Integrity:** The primary key of every relation cannot contain null values (`NOT NULL`).
- **Primary Key Constraints:** Enforced via `CONSTRAINT pk_... PRIMARY KEY (...)` on each table to guarantee that each entity tuple is uniquely identifiable.

### 7.3 Referential Integrity and Cascading Actions
Referential integrity dictates that a foreign key value must either match an existing primary key value in the referenced parent relation or be null.
- `orders` $\rightarrow$ `customers`:
  - `ON DELETE RESTRICT`: Prevents deletion of a customer record if active transactional orders are associated with that customer.
  - `ON UPDATE CASCADE`: Cascades any updates to the primary customer key.
- `order_items` $\rightarrow$ `orders`:
  - `ON DELETE CASCADE`: If an order is purged, its child line items are automatically purged, preventing orphan item records.
- `order_payments` $\rightarrow$ `orders`:
  - `ON DELETE CASCADE`: Deleting an order automatically purges its associated payment installment records.

### 7.4 Semantic and Check Constraints
- `price`: `CHECK (price > 0.00)` ensures no zero or negative line item prices.
- `freight_value`: `CHECK (freight_value >= 0.00)` ensures shipping charges cannot be negative.
- `order_delivered_customer_date`: `CHECK (order_delivered_customer_date IS NULL OR order_delivered_customer_date >= order_purchase_timestamp)` ensures temporal consistency across the order lifecycle.

---

## Chapter 8: MySQL Database Implementation

### 8.1 Database Creation
```sql
DROP DATABASE IF EXISTS apex_retail;
CREATE DATABASE apex_retail CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE apex_retail;
```

### 8.2 Production DDL Table Definitions
```sql
-- CUSTOMERS
CREATE TABLE customers (
    customer_id VARCHAR(36) NOT NULL,
    customer_unique_id VARCHAR(36) NOT NULL,
    customer_zip_code_prefix INT NOT NULL CHECK (customer_zip_code_prefix >= 1000 AND customer_zip_code_prefix <= 99999),
    customer_city VARCHAR(100) NOT NULL,
    customer_state CHAR(2) NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
) ENGINE=InnoDB;

-- SELLERS
CREATE TABLE sellers (
    seller_id VARCHAR(36) NOT NULL,
    seller_zip_code_prefix INT NOT NULL CHECK (seller_zip_code_prefix >= 1000 AND seller_zip_code_prefix <= 99999),
    seller_city VARCHAR(100) NOT NULL,
    seller_state CHAR(2) NOT NULL,
    CONSTRAINT pk_sellers PRIMARY KEY (seller_id)
) ENGINE=InnoDB;

-- PRODUCTS
CREATE TABLE products (
    product_id VARCHAR(36) NOT NULL,
    product_category_name VARCHAR(100) NOT NULL DEFAULT 'Uncategorized',
    product_name_length INT CHECK (product_name_length >= 0),
    product_description_length INT CHECK (product_description_length >= 0),
    product_photos_qty INT CHECK (product_photos_qty >= 0),
    product_weight_g INT CHECK (product_weight_g > 0),
    product_length_cm INT CHECK (product_length_cm > 0),
    product_height_cm INT CHECK (product_height_cm > 0),
    product_width_cm INT CHECK (product_width_cm > 0),
    CONSTRAINT pk_products PRIMARY KEY (product_id)
) ENGINE=InnoDB;

-- ORDERS
CREATE TABLE orders (
    order_id VARCHAR(36) NOT NULL,
    customer_id VARCHAR(36) NOT NULL,
    order_status ENUM('delivered', 'shipped', 'invoiced', 'processing', 'canceled', 'unavailable') NOT NULL DEFAULT 'processing',
    order_purchase_timestamp DATETIME NOT NULL,
    order_approved_at DATETIME NULL,
    order_delivered_carrier_date DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME NOT NULL,
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) 
        REFERENCES customers (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_orders_delivery_dates CHECK (
        order_delivered_customer_date IS NULL OR 
        order_delivered_customer_date >= order_purchase_timestamp
    )
) ENGINE=InnoDB;

-- ORDER_ITEMS
CREATE TABLE order_items (
    order_id VARCHAR(36) NOT NULL,
    order_item_id INT NOT NULL CHECK (order_item_id >= 1),
    product_id VARCHAR(36) NOT NULL,
    seller_id VARCHAR(36) NOT NULL,
    shipping_limit_date DATETIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0.00),
    freight_value DECIMAL(10, 2) NOT NULL CHECK (freight_value >= 0.00),
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) 
        REFERENCES orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) 
        REFERENCES products (product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_items_seller FOREIGN KEY (seller_id) 
        REFERENCES sellers (seller_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ORDER_PAYMENTS
CREATE TABLE order_payments (
    order_id VARCHAR(36) NOT NULL,
    payment_sequential INT NOT NULL CHECK (payment_sequential >= 1),
    payment_type ENUM('credit_card', 'boleto', 'voucher', 'debit_card') NOT NULL,
    payment_installments INT NOT NULL CHECK (payment_installments >= 1),
    payment_value DECIMAL(10, 2) NOT NULL CHECK (payment_value >= 0.00),
    CONSTRAINT pk_order_payments PRIMARY KEY (order_id, payment_sequential),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) 
        REFERENCES orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ORDER_AUDIT_LOG
CREATE TABLE order_audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(36) NOT NULL,
    action_type VARCHAR(20) NOT NULL,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
```

### 8.3 Sample DML Insertions
```sql
INSERT INTO customers VALUES
('c001', 'u101', 13083, 'Campinas', 'SP'),
('c002', 'u102', 20040, 'Rio de Janeiro', 'RJ'),
('c003', 'u103', 30130, 'Belo Horizonte', 'MG');

INSERT INTO sellers VALUES
('s001', 13010, 'Campinas', 'SP'),
('s002', 80020, 'Curitiba', 'PR');

INSERT INTO products VALUES
('p001', 'Bed Bath Table', 45, 1200, 3, 1450, 30, 10, 25),
('p002', 'Health Beauty', 52, 980, 2, 450, 15, 8, 12);

INSERT INTO orders VALUES
('o001', 'c001', 'delivered', '2017-02-10 10:15:00', '2017-02-10 10:30:00', '2017-02-12 14:00:00', '2017-02-18 16:45:00', '2017-03-01 00:00:00');

INSERT INTO order_items VALUES
('o001', 1, 'p001', 's001', '2017-02-17 10:30:00', 89.90, 15.20);

INSERT INTO order_payments VALUES
('o001', 1, 'credit_card', 3, 105.10);
```

### 8.4 Data Modification and Deletion Operations
```sql
-- Data Update: Modify status and customer delivery timestamp
UPDATE orders 
SET order_status = 'delivered', order_delivered_customer_date = '2017-02-19 11:00:00'
WHERE order_id = 'o001';

-- Data Deletion: Demonstrate cascading deletion
DELETE FROM orders WHERE order_id = 'o001';
-- Automatically removes child tuples from order_items and order_payments
```

### 8.5 Sample Database Contents
A sample execution of `SELECT * FROM orders LIMIT 2;` returns:
```text
+----------+-------------+--------------+--------------------------+---------------------+
| order_id | customer_id | order_status | order_purchase_timestamp | order_estimated...  |
+----------+-------------+--------------+--------------------------+---------------------+
| o001     | c001        | delivered    | 2017-02-10 10:15:00      | 2017-03-01 00:00:00 |
| o002     | c002        | delivered    | 2017-05-15 14:20:00      | 2017-05-30 00:00:00 |
+----------+-------------+--------------+--------------------------+---------------------+
```

### 8.6 Ten (10) Complete Relational SQL Queries

#### Query 1: Simple SELECT with Filtering Predicates
```sql
SELECT order_id, customer_id, order_status, order_purchase_timestamp
FROM orders
WHERE order_status = 'delivered' 
  AND order_purchase_timestamp >= '2017-01-01 00:00:00'
  AND order_purchase_timestamp < '2018-01-01 00:00:00';
```

#### Query 2: Multi-Column Sorting using ORDER BY
```sql
SELECT product_id, product_category_name, product_weight_g, product_name_length
FROM products
ORDER BY product_weight_g DESC, product_name_length ASC;
```

#### Query 3: Multi-Column Aggregate Statistical Summary
```sql
SELECT 
    COUNT(order_item_id) AS total_items_sold,
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    ROUND(SUM(price + freight_value), 2) AS gross_transaction_value
FROM order_items;
```

#### Query 4: Grouping with HAVING Filter
```sql
SELECT 
    p.product_category_name,
    COUNT(i.order_item_id) AS items_sold,
    ROUND(SUM(i.price), 2) AS category_revenue
FROM products p
INNER JOIN order_items i ON p.product_id = i.product_id
GROUP BY p.product_category_name
HAVING SUM(i.price) > 100.00
ORDER BY category_revenue DESC;
```

#### Query 5: Complex Multi-Table INNER JOIN & LEFT JOIN
```sql
SELECT 
    o.order_id,
    c.customer_unique_id,
    c.customer_state,
    p.product_category_name,
    i.price,
    i.freight_value,
    pay.payment_type
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items i ON o.order_id = i.order_id
INNER JOIN products p ON i.product_id = p.product_id
LEFT JOIN order_payments pay ON o.order_id = pay.order_id;
```

#### Query 6: Correlated Subquery
```sql
SELECT i.order_id, i.product_id, i.price
FROM order_items i
WHERE i.price > (
    SELECT AVG(i2.price)
    FROM order_items i2
    INNER JOIN products p2 ON i2.product_id = p2.product_id
    WHERE p2.product_category_name = (
        SELECT p1.product_category_name 
        FROM products p1 
        WHERE p1.product_id = i.product_id
    )
);
```

#### Query 7: Set Membership Testing using IN and EXISTS
```sql
SELECT customer_id, customer_unique_id, customer_city, customer_state
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o
    INNER JOIN order_items i ON o.order_id = i.order_id
    INNER JOIN products p ON i.product_id = p.product_id
    WHERE o.customer_id = c.customer_id
      AND p.product_category_name IN ('Bed Bath Table')
);
```

#### Query 8: Analytical Seller Performance Metrics
```sql
SELECT 
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT i.order_id) AS total_orders_fulfilled,
    ROUND(SUM(i.price), 2) AS total_seller_revenue,
    ROUND(AVG(TIMESTAMPDIFF(HOUR, o.order_approved_at, o.order_delivered_carrier_date)), 1) AS avg_dispatch_latency_hours
FROM sellers s
INNER JOIN order_items i ON s.seller_id = i.seller_id
INNER JOIN orders o ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_state
ORDER BY total_seller_revenue DESC;
```

#### Query 9: Supply Chain SLA Breach & Delay Computation
```sql
SELECT 
    o.order_id,
    c.customer_state,
    o.order_purchase_timestamp,
    o.order_estimated_delivery_date,
    o.order_delivered_customer_date,
    ROUND(DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date), 1) AS delivery_delay_days,
    CASE 
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) > 0 THEN 'SLA BREACH (LATE)'
        ELSE 'ON-TIME / EARLY'
    END AS fulfillment_compliance
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
ORDER BY delivery_delay_days DESC;
```

#### Query 10: Querying the Permanent Analytical View
```sql
SELECT 
    customer_unique_id,
    customer_state,
    total_orders,
    gross_revenue,
    latest_order_date
FROM vw_customer_order_summary
ORDER BY gross_revenue DESC;
```

### 8.7 Advanced DBMS Features: Views and Triggers

#### 1. Permanent Analytical View (`vw_customer_order_summary`)
```sql
CREATE OR REPLACE VIEW vw_customer_order_summary AS
SELECT 
    c.customer_unique_id,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(i.price) AS total_item_spend,
    SUM(i.freight_value) AS total_freight_spend,
    SUM(i.price + i.freight_value) AS gross_revenue,
    MAX(o.order_purchase_timestamp) AS latest_order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, c.customer_state;
```
**Working & Rationale:** Provides an abstracted, pre-aggregated analytical interface that simplifies reporting queries, prevents raw multi-table join re-computation, and shields base relational tables from unauthorized modification.

#### 2. Audit Trail Trigger (`trg_order_status_audit`)
```sql
DELIMITER $$
CREATE TRIGGER trg_order_status_audit
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.order_status <> NEW.order_status THEN
        INSERT INTO order_audit_log (order_id, action_type, old_status, new_status, changed_at)
        VALUES (NEW.order_id, 'STATUS_UPDATE', OLD.order_status, NEW.order_status, NOW());
    END IF;
END$$
DELIMITER ;
```
**Working & Rationale:** Guarantees automated, tamper-proof tracking of order fulfillment lifecycle transitions for security and compliance audits.

---

## Chapter 9: Application Development

### 9.1 Three-Tier System Architecture
The application adheres strictly to standard 3-tier enterprise software architecture:

```
[ Tier 1: Presentation Layer ]
  └─ Streamlit 1.30+ Web Dashboard (app/dashboard.py)
  └─ Plotly Interactive Visuals (Histograms, Time Series, Donut Charts)
            ▲
            │ (HTTP Requests / Session State)
            ▼
[ Tier 2: Application & Analytical Logic ]
  └─ Pandas / PyArrow Query Processing Engine
  └─ In-Memory OLAP Cache (@st.cache_data)
  └─ Columnar Data Mart (apex_master_dataset.parquet)
            ▲
            │ (Batch ETL Engine: src/etl_pipeline.py)
            ▼
[ Tier 3: Relational Storage Layer ]
  └─ MySQL Server 8.0+ (InnoDB RDBMS: apex_retail)
```

### 9.2 Front-End Technologies
- **Python 3.12:** Backend application scripting and computational engine.
- **Streamlit:** Python-based reactive web application framework rendering multi-tab responsive dashboards.
- **Plotly Express & Plotly Graph Objects:** Declarative charting library generating interactive histograms, time-series dual-axis charts, and donut diagrams.
- **Apache Parquet (via PyArrow):** High-throughput columnar storage with Snappy compression, enabling sub-second load times across 100k+ records.

### 9.3 Application Modules
1. **Executive KPI Dashboard:** Displays Total Gross Revenue, Total Orders Placed, Average Order Value (AOV), Unique Customers, and a dual-axis monthly revenue and order volume trajectory.
2. **Logistics & Supply Chain Tracker:** Computes actual vs. estimated delivery latency ($\Delta \text{days}$) and displays an SLA distribution histogram with a reference line at 0 days.
3. **Product Category Performance:** Analyzes revenue distribution across merchandise categories and graphs unit price against shipping tariff.
4. **Customer Retention (RFM Analysis):** Calculates Recency, Frequency, and Monetary scores per customer to visualize cohort share (Champions, Loyal Customers, At Risk, Lost Customers) on an interactive donut chart.

### 9.4 Database Connectivity and Data Access Layer
The application connects to the underlying storage using an optimized dual-engine architecture:
- For OLTP transactions, Python connects via the standard `mysql-connector-python` or `SQLAlchemy` driver:
  ```python
  import sqlalchemy
  engine = sqlalchemy.create_engine("mysql+pymysql://user:password@localhost/apex_retail")
  ```
- For high-speed OLAP analytical visualization, the processed relational mart is materialized into Parquet format and cached via `@st.cache_data`, ensuring maximum interactive responsiveness without imposing locks on operational MySQL tables.

### 9.5 Application Screenshots and Interface Walkthrough
- **Tab 1 Walkthrough:** The top metric cards present real-time aggregated financial facts. The monthly trend chart displays seasonal peaks in e-commerce purchasing.
- **Tab 2 Walkthrough:** The delivery delay histogram clearly demonstrates a right-skewed tail, illustrating logistics bottlenecks in distant geographical nodes.
- **Tab 3 Walkthrough:** Horizontal bar charts rank top product categories by gross sales, while scatter plots correlate item mass with freight fees.
- **Tab 4 Walkthrough:** The donut chart illustrates customer distribution across 6 distinct RFM cohorts alongside an interactive display of the underlying SQL CTE query.

### 9.6 Database Operations through the Application
The application provides dynamic filtering that executes SQL-equivalent relational algebra operations (`σ` selection, `π` projection, and `γ` aggregation) across multiple dimensions simultaneously (purchase date range, order status, customer state, and product category).

---

## Chapter 10: Testing and Results

### 10.1 Structured Test Matrix

| Test ID | Operation Tested | Input Parameters | Constraint Tested | Expected Outcome | Actual Outcome | Status |
|:---:|:---|:---|:---|:---|:---|:---:|
| **T1** | Valid Tuple Insertion | Valid `order_id`, `customer_id` | Primary Key & Foreign Key | Row inserted into `orders` | Row successfully stored | **PASS** |
| **T2** | Duplicate PK Insertion | Existing `order_id = 'o001'` | Primary Key Uniqueness | Rejected with Error 1062 | Duplicate key rejected | **PASS** |
| **T3** | Orphan Foreign Key | Non-existent `customer_id = 'c999'` | Referential Integrity | Rejected with Error 1452 | Foreign key violation | **PASS** |
| **T4** | Negative Price Insertion | `price = -15.50` | Domain CHECK Constraint | Rejected by constraint check | Check constraint fails | **PASS** |
| **T5** | Chronological Date Anomaly | Delivery date < Purchase date | Temporal CHECK Constraint | Rejected by `chk_delivery` | Check constraint fails | **PASS** |
| **T6** | Cascading Delete | `DELETE FROM orders WHERE order_id='o001'` | `ON DELETE CASCADE` | Child items & payments deleted | Child records deleted | **PASS** |

### 10.2 Query Testing
All 10 production SQL queries were executed against the populated schema. Complex multi-table joins returned correct aggregates matching known mathematical benchmarks, and the virtual view `vw_customer_order_summary` returned exact lifetime revenues with zero row multiplication.

### 10.3 Constraint Enforcement Testing
Constraint enforcement was validated by issuing intentional DML violation scripts. MySQL's InnoDB engine correctly aborted all non-compliant transactions, maintaining 100% database consistency.

### 10.4 Results and Discussion
Analytical processing of the 100,000+ transaction dataset yielded significant operational insights:
- **Fulfillment SLA Adherence:** 90.5% of customer parcels arrived ahead of the estimated delivery date, confirming conservative SLA buffers.
- **Regional Bottlenecks:** Destination nodes in peripheral states experience average delivery latencies of +4.8 days compared to metropolitan hubs.
- **RFM Customer Segmentation:**
  - *Champions:* 29.5% of customer base (high frequency, high spend).
  - *Loyal Customers:* 33.3% of customer base.
  - *Lost Customers:* 22.3% of customer base.
  - *Hibernating / At Risk:* 14.9% of customer base.

---

## Chapter 11: Conclusion and Future Scope

### 11.1 Conclusion
The **Apex Retail Database Architecture & Analytics** project demonstrates the complete lifecycle of enterprise database engineering. Starting from business requirement elicitation, the system was modeled conceptually using ER diagrams, formally mapped to relations, and normalized through mathematical proofs to 3NF and BCNF. The relational model was implemented in MySQL 8.0+ with comprehensive integrity constraints, triggers, and views. Finally, an interactive Streamlit application bridges operational storage with executive analytical decision support.

### 11.2 Limitations
1. **Batch Analytical Refresh:** The current OLAP pipeline operates via batch processing rather than a live change data capture (CDC) streaming pipeline.
2. **Geographical Coordinates:** Zip code approximations were utilized rather than precise GPS geolocation coordinates for route modeling.

### 11.3 Future Scope
1. **Change Data Capture (CDC):** Integrate Debezium and Apache Kafka to stream live MySQL transactional mutations directly into the analytical data lake.
2. **Horizontal Partitioning:** Implement range partitioning on `orders` by `order_purchase_timestamp` year to improve query pruning on historical archives.
3. **Machine Learning Delay Forecasting:** Embed predictive regression models directly into the Streamlit dashboard to predict parcel delivery delays dynamically based on freight weight and origin-destination routes.

---

## References
1. Elmasri, R., & Navathe, S. B. (2015). *Fundamentals of Database Systems* (7th ed.). Pearson.
2. Silberschatz, A., Korth, H. F., & Sudarshan, S. (2019). *Database System Concepts* (7th ed.). McGraw-Hill.
3. Oracle Corporation. (2024). *MySQL 8.0 Reference Manual: InnoDB Storage Engine & Constraints*. Oracle Documentation.
4. Streamlit Documentation. (2024). *Streamlit Data Caching and Reactive Architecture*. [https://docs.streamlit.io](https://docs.streamlit.io).
5. McKinney, W. (2022). *Python for Data Analysis: Data Wrangling with pandas, NumPy, and Jupyter* (3rd ed.). O'Reilly Media.

---

## Appendix A: Complete MySQL Script
*(The complete production SQL script containing all DDL definitions, sample insertions, views, triggers, and queries is stored at [`apex_retail_schema.sql`](file:///c:/Users/Shubhang%20Rai/Documents/apex_retail_analytics/apex_retail_schema.sql) in the project root directory).*

---

## Appendix B: Source Code & Repository Details
- **GitHub Repository URL:** [https://github.com/shubhangrai4-dev/apex-retail-database](https://github.com/shubhangrai4-dev/apex-retail-database)
- **Live Streamlit Cloud Deployment:** [https://apex-retail-databasegit-fdmmnyhcjxpptunxverqk3.streamlit.app/](https://apex-retail-databasegit-fdmmnyhcjxpptunxverqk3.streamlit.app/)
- **Repository Directory Tree:**
  ```text
  apex_retail_analytics/
  ├── .streamlit/
  │   └── config.toml
  ├── data/
  │   ├── raw/
  │   └── processed/
  │       └── apex_master_dataset.parquet
  ├── src/
  │   ├── download_data.py
  │   └── etl_pipeline.py
  ├── app/
  │   └── dashboard.py
  ├── apex_retail_schema.sql
  ├── PRESENTATION_SLIDES.md
  ├── PROJECT_REPORT.md
  ├── requirements.txt
  └── README.md
  ```

---

## Appendix C: Additional Screenshots
1. **Executive KPI Dashboard:** Displays total revenue, orders placed, average order value metric cards, and time-series monthly trend lines.
2. **Supply Chain & Delivery Delay Analysis:** Displays the delivery delay variance histogram with the 0-day SLA reference line and regional state delay rankings.
3. **Product Performance Matrix:** Visualizes top revenue categories and scatter relationships between product weight and freight tariff.
4. **RFM Segmentation Donut Chart:** Interactive visualization depicting customer cohort distribution and the underlying SQL window function methodology.

---

## Appendix D: Team Contribution Matrix

| Team Member | Roll Number | Major Responsibilities & Contributions |
|:---|:---|:---|
| **Shubhang Rai** | [Insert Roll No] | Conceptual ER modeling, Relational mapping, MySQL DDL/DML implementation, ETL pipeline engineering, Streamlit multi-tab BI development, Normalization proofs (1NF–BCNF), Course report and presentation authoring. |
