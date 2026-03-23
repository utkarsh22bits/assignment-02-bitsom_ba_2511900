## Anomaly Analysis

### Insert Anomaly

In the orders_flat.csv dataset, a new customer cannot be added without creating an order entry because customer details are stored along with order information. 

For example, customer_id = 'C010' cannot be inserted unless an order_id is also created, since fields like order_id, product_id, and quantity are required.

### Update Anomaly

Customer details such as city are repeated in multiple rows. 

For example, customer 'Rohan Iyer' (customer_id = 'C001') appears in multiple rows. If his city changes from Mumbai to Pune, it must be updated in all rows. Missing even one row will lead to inconsistent data.

### Delete Anomaly

If an order is deleted, related customer and product information may also be lost. 

For example, if customer_id = 'C005' has only one order and that row is deleted, all their details (name, city) will also be removed from the dataset.

### Normalization Justification

Keeping all data in one table may seem simple, but it leads to redundancy and inconsistencies. In the dataset, customer and product information is repeated across multiple rows for each order, which increases storage and causes update anomalies.

By normalizing the data into separate tables such as Customers, Orders, Products, and Sales_Representatives, redundancy is reduced and consistency is maintained. Each entity is stored only once and linked using foreign keys.

Normalization to Third Normal Form (3NF) ensures that all attributes depend only on the primary key and removes transitive dependencies. This improves data integrity, scalability, and maintainability.

Although normalization introduces joins, the benefits of accuracy, reduced redundancy, and better data management outweigh the complexity. Therefore, normalization is necessary and not over-engineering.
