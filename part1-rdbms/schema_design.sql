-- ============================================================
-- Part 1.2: Schema Design — Third Normal Form (3NF)
-- Normalized from orders_flat.csv
-- Products: Laptop, Mouse, Desk Chair, Notebook, Headphones,
--           Standing Desk, Pen Set, Webcam
-- Categories: Electronics, Furniture, Stationery
-- ============================================================


-- ============================================================
-- Table 1: sales_reps
-- Stores rep info and their office address ONCE (eliminates update anomaly)
-- ============================================================
CREATE TABLE sales_reps (
    sales_rep_id   VARCHAR(10)  NOT NULL,
    rep_name       VARCHAR(100) NOT NULL,
    rep_email      VARCHAR(150) NOT NULL UNIQUE,
    office_address VARCHAR(255) NOT NULL,
    PRIMARY KEY (sales_rep_id)
);

-- ============================================================
-- Table 2: customers
-- Stores customer info independently (eliminates insert/delete anomalies)
-- ============================================================
CREATE TABLE customers (
    customer_id    VARCHAR(10)  NOT NULL,
    customer_name  VARCHAR(100) NOT NULL,
    customer_email VARCHAR(150) NOT NULL UNIQUE,
    customer_city  VARCHAR(100) NOT NULL,
    PRIMARY KEY (customer_id)
);

-- ============================================================
-- Table 3: products
-- Stores product master data independently (eliminates delete anomaly)
-- ============================================================
CREATE TABLE products (
    product_id       VARCHAR(10)   NOT NULL,
    product_name     VARCHAR(150)  NOT NULL,
    category         VARCHAR(100)  NOT NULL,
    unit_price       DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (product_id)
);

-- ============================================================
-- Table 4: orders
-- Stores one row per order, linking customer and sales rep
-- ============================================================
CREATE TABLE orders (
    order_id     VARCHAR(15)  NOT NULL,
    order_date   DATE         NOT NULL,
    customer_id  VARCHAR(10)  NOT NULL,
    sales_rep_id VARCHAR(10)  NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id)  REFERENCES customers(customer_id),
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

-- ============================================================
-- Table 5: order_items
-- One row per product per order (handles multiple products per order)
-- ============================================================
CREATE TABLE order_items (
    item_id     INT           NOT NULL AUTO_INCREMENT,
    order_id    VARCHAR(15)   NOT NULL,
    product_id  VARCHAR(10)   NOT NULL,
    quantity    INT           NOT NULL,
    unit_price  DECIMAL(10,2) NOT NULL,
    total_value DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (item_id),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ============================================================
-- INSERT: sales_reps (standardized office addresses)
-- ============================================================
INSERT INTO sales_reps (sales_rep_id, rep_name, rep_email, office_address) VALUES
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai',  'anita@corp.com',  'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar',   'ravi@corp.com',   'South Zone, MG Road, Bangalore - 560001'),
('SR04', 'Meena Kapoor', 'meena@corp.com',  'West Zone, Andheri East, Mumbai - 400069'),
('SR05', 'Suresh Pillai','suresh@corp.com', 'North Zone, Sector 18, Noida - 201301');

-- ============================================================
-- INSERT: customers
-- ============================================================
INSERT INTO customers (customer_id, customer_name, customer_email, customer_city) VALUES
('C001', 'Rohan Mehta',  'rohan@gmail.com',  'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com',  'Delhi'),
('C003', 'Amit Verma',   'amit@gmail.com',   'Bangalore'),
('C004', 'Sneha Iyer',   'sneha@gmail.com',  'Chennai'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta',   'neha@gmail.com',   'Delhi'),
('C007', 'Arjun Nair',   'arjun@gmail.com',  'Bangalore'),
('C008', 'Kavya Rao',    'kavya@gmail.com',  'Hyderabad');

-- ============================================================
-- INSERT: products (all 8 products from orders_flat.csv)
-- ============================================================
INSERT INTO products (product_id, product_name, category, unit_price) VALUES
('P001', 'Laptop',        'Electronics', 55000.00),
('P002', 'Mouse',         'Electronics',   800.00),
('P003', 'Desk Chair',    'Furniture',    8500.00),
('P004', 'Notebook',      'Stationery',    120.00),
('P005', 'Headphones',    'Electronics',  3200.00),
('P006', 'Standing Desk', 'Furniture',   22000.00),
('P007', 'Pen Set',       'Stationery',    250.00),
('P008', 'Webcam',        'Electronics',  2100.00);

-- ============================================================
-- INSERT: orders (at least 5)
-- ============================================================
INSERT INTO orders (order_id, order_date, customer_id, sales_rep_id) VALUES
('ORD1027', '2023-11-02', 'C002', 'SR02'),
('ORD1114', '2023-08-06', 'C001', 'SR01'),
('ORD1002', '2023-01-17', 'C002', 'SR02'),
('ORD1075', '2023-04-18', 'C005', 'SR03'),
('ORD1091', '2023-07-24', 'C001', 'SR01'),
('ORD1185', '2023-06-15', 'C003', 'SR03'),
('ORD1076', '2023-05-16', 'C004', 'SR03'),
('ORD1061', '2023-10-27', 'C006', 'SR01'),
('ORD1095', '2023-08-11', 'C001', 'SR03'),
('ORD1098', '2023-10-03', 'C007', 'SR03');

-- ============================================================
-- INSERT: order_items (at least 5)
-- ============================================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_value) VALUES
('ORD1027', 'P004', 4,   120.00,   480.00),
('ORD1114', 'P007', 2,   250.00,   500.00),
('ORD1002', 'P005', 1,  3200.00,  3200.00),
('ORD1075', 'P003', 3,  8500.00, 25500.00),
('ORD1091', 'P006', 3, 22000.00, 66000.00),
('ORD1185', 'P008', 1,  2100.00,  2100.00),
('ORD1076', 'P006', 5, 22000.00,110000.00),
('ORD1061', 'P001', 4, 55000.00,220000.00),
('ORD1095', 'P001', 3, 55000.00,165000.00),
('ORD1098', 'P001', 2, 55000.00,110000.00);
