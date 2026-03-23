-- Dimension Tables

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE,
    month INT,
    year INT
);

CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

-- Fact Table

CREATE TABLE fact_sales (
    sale_id INT PRIMARY KEY,
    date_id INT,
    store_id INT,
    product_id INT,
    quantity INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- Sample Data

INSERT INTO dim_date VALUES
(1,'2023-01-01',1,2023),
(2,'2023-02-01',2,2023),
(3,'2023-03-01',3,2023);

INSERT INTO dim_store VALUES
(1,'Store A','Mumbai'),
(2,'Store B','Delhi'),
(3,'Store C','Bangalore');

INSERT INTO dim_product VALUES
(1,'Laptop','Electronics'),
(2,'Shirt','Clothing'),
(3,'Milk','Groceries');

INSERT INTO fact_sales VALUES
(1,1,1,1,2,100000),
(2,2,2,2,5,5000),
(3,3,3,3,10,600),
(4,1,2,1,1,50000),
(5,2,3,2,3,3000),
(6,3,1,3,8,480),
(7,1,3,1,2,100000),
(8,2,1,2,4,4000),
(9,3,2,3,6,360),
(10,1,1,2,3,3000);
