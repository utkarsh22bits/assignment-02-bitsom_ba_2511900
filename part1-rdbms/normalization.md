# Normalization Analysis

## Anomaly Analysis

### Insert Anomaly
**Definition:** You cannot insert certain data without being forced to include other unrelated data.

**Example from orders_flat.csv:**
Suppose the company hires a new sales representative — say, Meena Kapoor (SR04, meena@corp.com, West Zone Office, Andheri, Mumbai). There is **no way to add her record** to the flat table because every row requires an `order_id`, `customer_id`, and `product_id`. Since Meena has not yet handled any orders, her details simply cannot be stored. Similarly, if the company wants to add a new product like "Ergonomic Chair" to the catalog before it is sold, that is also impossible — the flat table has no place for a product that has not appeared in an order.

**Rows/Columns affected:** `sales_rep_id`, `sales_rep_name`, `sales_rep_email`, `office_address` — all require a complete order row to exist before data can be inserted.

---

### Update Anomaly
**Definition:** Changing one piece of information requires updating multiple rows, creating a risk of inconsistency.

**Example from orders_flat.csv:**
Sales Representative SR01 (Deepak Joshi, deepak@corp.com) is associated with dozens of orders. His `office_address` appears as "Mumbai HQ, Nariman Point, Mumbai - 400021" in most rows — but in rows ORD1170, ORD1172, ORD1176, ORD1177, ORD1179, ORD1181, ORD1183, ORD1184, it appears as the abbreviated "Mumbai HQ, Nariman Pt, Mumbai - 400021". This inconsistency is a textbook update anomaly — the same address was updated in some rows but not all. If Deepak's office moves, **every single one of his order rows** must be updated. Even one missed row produces corrupted, contradictory data.

**Rows/Columns affected:** `office_address` for `sales_rep_id = SR01` — inconsistency already present across rows for Deepak Joshi.

---

### Delete Anomaly
**Definition:** Deleting a row to remove one piece of information accidentally destroys unrelated, valuable data.

**Example from orders_flat.csv:**
Product **P008 (Webcam, Electronics, ₹2,100)** appears in exactly **one row** — order `ORD1185` placed by customer C003 (Amit Verma, Bangalore). If this order is cancelled and deleted from the system, **all information about the Webcam product** is permanently erased — its product ID, name, category, and price vanish from the database entirely, even though the product may still be in inventory and available for sale. The deletion of a single business transaction destroys unrelated product master data.

**Rows/Columns affected:** Deleting `order_id = ORD1185` destroys `product_id = P008`, `product_name = Webcam`, `category = Electronics`, `unit_price = 2100`.

---

## Normalization Justification

### The Manager's Argument vs. Reality

A manager might argue that the single flat file (`orders_flat.csv`) is simpler to manage — one file, one query, no confusing joins. For a dataset with 150 rows, this argument has surface appeal. However, the real dataset exposes how quickly this assumption collapses under real-world conditions.

Consider the `office_address` column for sales representative Deepak Joshi (SR01). His address appears in over 40 rows. A quick scan of the actual data reveals it has already become inconsistent: most rows show "Nariman Point" while several show the abbreviated "Nariman Pt." This is not a hypothetical risk — the update anomaly has already happened in the provided dataset. In a growing business with hundreds of reps and thousands of orders, this problem compounds daily. Every time a rep changes office locations, a developer must hunt down and fix every row associated with that rep, and one missed update silently corrupts reports.

The Webcam (P008) example shows an even starker problem. A product exists in the company's catalog — it is presumably in stock, has a price, and belongs to a category. But in this flat table, its existence depends entirely on a customer choosing to order it. Delete that one order, and the product disappears from the system forever. No catalog, no inventory record, nothing. A normalized design stores products independently, so deleting an order never touches product master data.

The flat file also makes it impossible to onboard a new sales representative before they close their first deal. The table has no way to record "Meena Kapoor joined the sales team today." She only comes into existence once she generates revenue. This is not simplicity — it is a structural limitation masquerading as simplicity.

Normalization to 3NF resolves all three anomalies by giving each entity (Customer, Product, SalesRep, Order, OrderItem) its own table and its own primary key. Each fact is stored exactly once. Joins are handled by the database engine — fast, reliable, and invisible to end users. The manager's concern about complexity is valid for a 5-row spreadsheet; it is a dangerous false economy for any system expected to grow.
