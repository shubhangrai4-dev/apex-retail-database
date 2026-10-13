-- ============================================================================
-- Apex Retail Enterprise Database Schema & Analytical Queries
-- Course: CS301 - Database Management Systems (DBMS)
-- Institution: Indian Institute of Information Technology (IIIT) Bhopal
-- Academic Session: 2026–2027 (Monsoon Semester)
-- Course Instructor: Priyankar
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. DATABASE INITIALIZATION
-- ----------------------------------------------------------------------------
DROP DATABASE IF EXISTS apex_retail;
CREATE DATABASE apex_retail CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE apex_retail;

-- ----------------------------------------------------------------------------
-- 2. TABLE CREATION WITH CONSTRAINTS (DDL)
-- ----------------------------------------------------------------------------

-- Entity 1: CUSTOMERS (Strong Entity)
CREATE TABLE customers (
    customer_id VARCHAR(36) NOT NULL,
    customer_unique_id VARCHAR(36) NOT NULL,
    customer_zip_code_prefix INT NOT NULL CHECK (customer_zip_code_prefix >= 1000 AND customer_zip_code_prefix <= 99999),
    customer_city VARCHAR(100) NOT NULL,
    customer_state CHAR(2) NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
) ENGINE=InnoDB;

-- Entity 2: SELLERS (Strong Entity)
CREATE TABLE sellers (
    seller_id VARCHAR(36) NOT NULL,
    seller_zip_code_prefix INT NOT NULL CHECK (seller_zip_code_prefix >= 1000 AND seller_zip_code_prefix <= 99999),
    seller_city VARCHAR(100) NOT NULL,
    seller_state CHAR(2) NOT NULL,
    CONSTRAINT pk_sellers PRIMARY KEY (seller_id)
) ENGINE=InnoDB;

-- Entity 3: PRODUCTS (Strong Entity)
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

-- Entity 4: ORDERS (Central Transaction Entity)
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
        REFERENCES customers (customer_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT chk_orders_delivery_dates CHECK (
        order_delivered_customer_date IS NULL OR 
        order_delivered_customer_date >= order_purchase_timestamp
    )
) ENGINE=InnoDB;

-- Entity 5: ORDER_ITEMS (Associative Composite Entity: M:N Orders ↔ Products)
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
        REFERENCES orders (order_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) 
        REFERENCES products (product_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT fk_items_seller FOREIGN KEY (seller_id) 
        REFERENCES sellers (seller_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Entity 6: ORDER_PAYMENTS (Weak Associative Entity dependent on Orders)
CREATE TABLE order_payments (
    order_id VARCHAR(36) NOT NULL,
    payment_sequential INT NOT NULL CHECK (payment_sequential >= 1),
    payment_type ENUM('credit_card', 'boleto', 'voucher', 'debit_card') NOT NULL,
    payment_installments INT NOT NULL CHECK (payment_installments >= 1),
    payment_value DECIMAL(10, 2) NOT NULL CHECK (payment_value >= 0.00),
    CONSTRAINT pk_order_payments PRIMARY KEY (order_id, payment_sequential),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) 
        REFERENCES orders (order_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Entity 7: ORDER_AUDIT_LOG (Operational Audit Table for Triggers)
CREATE TABLE order_audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(36) NOT NULL,
    action_type VARCHAR(20) NOT NULL,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 3. SAMPLE DATA INSERTION (DML)
-- ----------------------------------------------------------------------------

-- Insert Customers
INSERT INTO customers (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state) VALUES
('c001', 'u101', 13083, 'Campinas', 'SP'),
('c002', 'u102', 20040, 'Rio de Janeiro', 'RJ'),
('c003', 'u103', 30130, 'Belo Horizonte', 'MG'),
('c004', 'u104', 80010, 'Curitiba', 'PR'),
('c005', 'u101', 13083, 'Campinas', 'SP'); -- Repeat customer u101

-- Insert Sellers
INSERT INTO sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state) VALUES
('s001', 13010, 'Campinas', 'SP'),
('s002', 80020, 'Curitiba', 'PR'),
('s003', 30150, 'Belo Horizonte', 'MG');

-- Insert Products
INSERT INTO products (product_id, product_category_name, product_name_length, product_description_length, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm) VALUES
('p001', 'Bed Bath Table', 45, 1200, 3, 1450, 30, 10, 25),
('p002', 'Health Beauty', 52, 980, 2, 450, 15, 8, 12),
('p003', 'Sports Leisure', 38, 1400, 4, 3200, 50, 20, 30),
('p004', 'Computers Accessories', 60, 2100, 5, 850, 25, 5, 18);

-- Insert Orders
INSERT INTO orders (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date) VALUES
('o001', 'c001', 'delivered', '2017-02-10 10:15:00', '2017-02-10 10:30:00', '2017-02-12 14:00:00', '2017-02-18 16:45:00', '2017-03-01 00:00:00'),
('o002', 'c002', 'delivered', '2017-05-15 14:20:00', '2017-05-15 14:50:00', '2017-05-18 09:30:00', '2017-06-05 11:20:00', '2017-05-30 00:00:00'), -- Delayed order!
('o003', 'c003', 'delivered', '2017-08-22 08:45:00', '2017-08-22 09:00:00', '2017-08-24 16:15:00', '2017-08-29 14:30:00', '2017-09-10 00:00:00'),
('o004', 'c004', 'shipped',   '2018-01-05 11:00:00', '2018-01-05 11:20:00', '2018-01-07 10:00:00', NULL,                  '2018-01-25 00:00:00'),
('o005', 'c005', 'delivered', '2018-03-12 18:30:00', '2018-03-12 18:45:00', '2018-03-14 12:00:00', '2018-03-20 15:10:00', '2018-04-02 00:00:00');

-- Insert Order Items
INSERT INTO order_items (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value) VALUES
('o001', 1, 'p001', 's001', '2017-02-17 10:30:00', 89.90, 15.20),
('o001', 2, 'p002', 's002', '2017-02-17 10:30:00', 45.00, 10.50),
('o002', 1, 'p004', 's001', '2017-05-22 14:50:00', 219.00, 24.80),
('o003', 1, 'p003', 's003', '2017-08-29 09:00:00', 135.50, 18.40),
('o004', 1, 'p002', 's002', '2018-01-12 11:20:00', 45.00, 12.00),
('o005', 1, 'p001', 's001', '2018-03-19 18:45:00', 92.00, 16.10);

-- Insert Order Payments
INSERT INTO order_payments (order_id, payment_sequential, payment_type, payment_installments, payment_value) VALUES
('o001', 1, 'credit_card', 3, 160.60),
('o002', 1, 'boleto',      1, 243.80),
('o003', 1, 'credit_card', 2, 153.90),
('o004', 1, 'voucher',     1, 57.00),
('o005', 1, 'credit_card', 1, 108.10);

-- ----------------------------------------------------------------------------
-- 4. ADVANCED DBMS FEATURES: VIEWS & TRIGGERS
-- ----------------------------------------------------------------------------

-- Feature 1: Materialized Analytical View
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

-- Feature 2: Trigger for Lifecycle Audit
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

-- ----------------------------------------------------------------------------
-- 5. TEN (10) PRODUCTION SQL QUERIES (Course Evaluation Requirements)
-- ----------------------------------------------------------------------------

-- Query 1: Simple SELECT with Filtering Predicates
-- Purpose: Retrieve all orders that were purchased in 2017 and have been marked delivered.
SELECT order_id, customer_id, order_status, order_purchase_timestamp
FROM orders
WHERE order_status = 'delivered' 
  AND order_purchase_timestamp >= '2017-01-01 00:00:00'
  AND order_purchase_timestamp < '2018-01-01 00:00:00';

-- Query 2: Multi-Column Sorting using ORDER BY
-- Purpose: List all products sorted by their weight descending, and name length ascending.
SELECT product_id, product_category_name, product_weight_g, product_name_length
FROM products
ORDER BY product_weight_g DESC, product_name_length ASC;

-- Query 3: Multi-Column Aggregate Statistical Summary
-- Purpose: Compute total line items sold, overall average item price, minimum and maximum transaction prices.
SELECT 
    COUNT(order_item_id) AS total_items_sold,
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    ROUND(SUM(price + freight_value), 2) AS gross_transaction_value
FROM order_items;

-- Query 4: Grouping with HAVING Filter
-- Purpose: Identify product categories that have generated gross item sales exceeding $100.
SELECT 
    p.product_category_name,
    COUNT(i.order_item_id) AS items_sold,
    ROUND(SUM(i.price), 2) AS category_revenue
FROM products p
INNER JOIN order_items i ON p.product_id = i.product_id
GROUP BY p.product_category_name
HAVING SUM(i.price) > 100.00
ORDER BY category_revenue DESC;

-- Query 5: Complex Multi-Table INNER JOIN & LEFT JOIN
-- Purpose: Complete transaction ledger connecting orders, customers, items, products, and payments.
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

-- Query 6: Correlated Subquery
-- Purpose: Find order items where the item price exceeds the average item price for that specific product category.
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

-- Query 7: Set Membership Testing using IN and EXISTS
-- Purpose: Identify all unique customers who have made at least one purchase in the 'Bed Bath Table' category.
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

-- Query 8: Analytical Seller Performance Metrics
-- Purpose: Compute total revenue and average fulfillment dispatch latency per seller.
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

-- Query 9: Supply Chain SLA Breach & Delay Computation
-- Purpose: Calculate exact delivery delay in days compared to promised SLA and identify late shipments.
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

-- Query 10: Querying the Permanent Analytical View
-- Purpose: Retrieve high-value customers with repeat purchase activity.
SELECT 
    customer_unique_id,
    customer_state,
    total_orders,
    gross_revenue,
    latest_order_date
FROM vw_customer_order_summary
ORDER BY gross_revenue DESC;
