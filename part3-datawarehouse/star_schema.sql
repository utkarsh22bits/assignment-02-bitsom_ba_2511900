-- ============================================================
-- Part 3.1: Star Schema — Retail Data Warehouse
-- Based on retail_transactions.csv
-- =============================================================

-- ============================================================
-- DIMENSION TABLE 1: dim_date
-- ============================================================
CREATE TABLE dim_date (
    date_id    INT         NOT NULL,
    full_date  DATE        NOT NULL,
    day        INT         NOT NULL,
    month      INT         NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter    INT         NOT NULL,
    year       INT         NOT NULL,
    is_weekend BOOLEAN     NOT NULL DEFAULT FALSE,
    PRIMARY KEY (date_id)
);

-- ============================================================
-- DIMENSION TABLE 2: dim_store
-- store_id derived from store_name (no store_id in raw data)
-- ============================================================
CREATE TABLE dim_store (
    store_id   VARCHAR(10)  NOT NULL,
    store_name VARCHAR(150) NOT NULL,
    store_city VARCHAR(100) NOT NULL,
    PRIMARY KEY (store_id)
);

-- ============================================================
-- DIMENSION TABLE 3: dim_product
-- category standardized to Title Case (Electronics/Clothing/Groceries)
-- ============================================================
CREATE TABLE dim_product (
    product_id   VARCHAR(10)  NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    category     VARCHAR(100) NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (product_id)
);

-- ============================================================
-- FACT TABLE: fact_sales
-- ============================================================
CREATE TABLE fact_sales (
    sale_id        INT           NOT NULL AUTO_INCREMENT,
    transaction_id VARCHAR(20)   NOT NULL UNIQUE,
    date_id        INT           NOT NULL,
    store_id       VARCHAR(10)   NOT NULL,
    product_id     VARCHAR(10)   NOT NULL,
    units_sold     INT           NOT NULL,
    unit_price     DECIMAL(10,2) NOT NULL,
    total_amount   DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (date_id)    REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id)   REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- ============================================================
-- INSERT: dim_date (representative dates from transactions)
-- ============================================================
INSERT INTO dim_date (date_id, full_date, day, month, month_name, quarter, year, is_weekend) VALUES
(20230101, '2023-01-01', 1,  1, 'January',   1, 2023, TRUE),
(20230111, '2023-01-11', 11, 1, 'January',   1, 2023, FALSE),
(20230115, '2023-01-15', 15, 1, 'January',   1, 2023, FALSE),
(20230205, '2023-02-05', 5,  2, 'February',  1, 2023, FALSE),
(20230208, '2023-02-08', 8,  2, 'February',  1, 2023, FALSE),
(20230302, '2023-03-02', 2,  3, 'March',     1, 2023, FALSE),
(20230331, '2023-03-31', 31, 3, 'March',     1, 2023, FALSE),
(20230414, '2023-04-14', 14, 4, 'April',     2, 2023, FALSE),
(20230521, '2023-05-21', 21, 5, 'May',       2, 2023, FALSE),
(20230604, '2023-06-04', 4,  6, 'June',      2, 2023, FALSE),
(20230722, '2023-07-22', 22, 7, 'July',      3, 2023, FALSE),
(20230801, '2023-08-01', 1,  8, 'August',    3, 2023, FALSE),
(20230809, '2023-08-09', 9,  8, 'August',    3, 2023, FALSE),
(20230829, '2023-08-29', 29, 8, 'August',    3, 2023, FALSE),
(20231003, '2023-10-03', 3,  10,'October',   4, 2023, FALSE),
(20231026, '2023-10-26', 26, 10,'October',   4, 2023, FALSE),
(20231118, '2023-11-18', 18, 11,'November',  4, 2023, FALSE),
(20231208, '2023-12-08', 8,  12,'December',  4, 2023, FALSE),
(20231212, '2023-12-12', 12, 12,'December',  4, 2023, FALSE),
(20231226, '2023-12-26', 26, 12,'December',  4, 2023, FALSE);

-- ============================================================
-- INSERT: dim_store (store_id derived from store_name)
-- Null store_city rows recovered from store_name lookup
-- ============================================================
INSERT INTO dim_store (store_id, store_name, store_city) VALUES
('S01', 'Chennai Anna',    'Chennai'),
('S02', 'Delhi South',     'Delhi'),
('S03', 'Bangalore MG',    'Bangalore'),
('S04', 'Pune FC Road',    'Pune'),
('S05', 'Mumbai Central',  'Mumbai');

-- ============================================================
-- INSERT: dim_product (category standardized to Title Case)
-- 'electronics'→'Electronics', 'Grocery'/'Groceries'→'Groceries'
-- ============================================================
INSERT INTO dim_product (product_id, product_name, category, unit_price) VALUES
('PR01', 'Speaker',    'Electronics', 49262.78),
('PR02', 'Tablet',     'Electronics', 23226.12),
('PR03', 'Phone',      'Electronics', 48703.39),
('PR04', 'Smartwatch', 'Electronics', 58851.01),
('PR05', 'Laptop',     'Electronics', 42343.15),
('PR06', 'Headphones', 'Electronics', 39854.96),
('PR07', 'Jeans',      'Clothing',     2317.47),
('PR08', 'Jacket',     'Clothing',    30187.24),
('PR09', 'Saree',      'Clothing',    35451.81),
('PR10', 'T-Shirt',    'Clothing',    29770.19),
('PR11', 'Atta 10kg',  'Groceries',   52464.00),
('PR12', 'Milk 1L',    'Groceries',   43374.39),
('PR13', 'Biscuits',   'Groceries',   27469.99),
('PR14', 'Rice 5kg',   'Groceries',   52195.05),
('PR15', 'Pulses 1kg', 'Groceries',   31604.47),
('PR16', 'Oil 1L',     'Groceries',   26474.34);

-- ============================================================
-- INSERT: fact_sales (15+ cleaned rows)
-- ============================================================
INSERT INTO fact_sales (transaction_id, date_id, store_id, product_id, units_sold, unit_price, total_amount) VALUES
('TXN5000', 20230829, 'S01', 'PR01',  3, 49262.78, 147788.34),
('TXN5001', 20231212, 'S01', 'PR02', 11, 23226.12, 255487.32),
('TXN5002', 20230205, 'S01', 'PR03', 20, 48703.39, 974067.80),
('TXN5003', 20230205, 'S02', 'PR02', 14, 23226.12, 325165.68),
('TXN5004', 20230115, 'S01', 'PR04', 10, 58851.01, 588510.10),
('TXN5005', 20230809, 'S03', 'PR11', 12, 52464.00, 629568.00),
('TXN5007', 20231026, 'S04', 'PR07', 16,  2317.47,  37079.52),
('TXN5008', 20231208, 'S03', 'PR13',  9, 27469.99, 247229.91),
('TXN5010', 20230604, 'S01', 'PR08', 15, 30187.24, 452808.60),
('TXN5011', 20231026, 'S05', 'PR07', 13,  2317.47,  30127.11),
('TXN5012', 20230521, 'S03', 'PR05', 13, 42343.15, 550461.95),
('TXN5014', 20231118, 'S02', 'PR08',  5, 30187.24, 150936.20),
('TXN5016', 20230801, 'S05', 'PR09', 11, 35451.81, 389969.91),
('TXN5018', 20230208, 'S03', 'PR06', 15, 39854.96, 597824.40);
