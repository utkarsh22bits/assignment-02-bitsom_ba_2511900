# NoSQL vs RDBMS Analysis

## Database Recommendation

### Healthcare Patient Management System: MySQL vs MongoDB

For a healthcare patient management system, I would recommend **MySQL (a relational database)** as the primary database. Here is my reasoning, grounded in ACID, BASE, and the CAP theorem.

**ACID vs BASE:** Healthcare data demands ACID compliance — Atomicity, Consistency, Isolation, and Durability. When a doctor writes a prescription or a nurse updates a patient's vitals, that transaction must complete fully or not at all. A partial write — say, a medication being recorded but the dosage not saved — could be life-threatening. MySQL guarantees this. MongoDB, following the BASE model (Basically Available, Soft state, Eventually consistent), sacrifices strict consistency for availability and performance. In healthcare, eventual consistency is unacceptable: a doctor querying a patient's allergy history cannot receive stale data.

**CAP Theorem:** Under the CAP theorem, distributed systems can only guarantee two of three properties: Consistency, Availability, or Partition tolerance. MySQL (in a single-node or master-slave setup) prioritizes Consistency and Partition tolerance (CP). MongoDB is typically configured as AP (Available and Partition tolerant), meaning it may return slightly outdated records during a network partition. For patient safety, CP is the correct trade-off.

**Structured, Relational Data:** Patient data is highly structured and deeply relational — patients have appointments, appointments link to doctors, doctors belong to departments, prescriptions reference medications, and lab results connect to diagnoses. SQL's JOIN operations and foreign key constraints model these relationships naturally and enforce referential integrity.

**Fraud Detection Module — Would My Answer Change?**

Yes, partially. A fraud detection module requires high-speed analysis of transaction patterns, anomaly detection across millions of payment records, and flexible schema for evolving fraud signals. This is where MongoDB or a combination approach makes sense. I would recommend a **polyglot persistence architecture**: MySQL for core patient records and clinical data (where ACID and consistency are non-negotiable), and MongoDB or Apache Cassandra for the fraud detection layer (where write speed, schema flexibility, and horizontal scalability matter more than strict consistency). This hybrid approach uses each database where it excels, rather than forcing one tool to serve conflicting requirements.
