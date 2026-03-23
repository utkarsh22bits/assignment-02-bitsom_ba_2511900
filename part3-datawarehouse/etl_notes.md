# ETL Notes — Retail Data Warehouse

## ETL Decisions

### Decision 1 — Standardizing Mixed Date Formats

**Problem:** The `date` column contains dates in four inconsistent formats across 300 rows: ISO (`2023-02-05`), slash-separated (`29/08/2023`), hyphen-separated (`12-12-2023`), and mixed (`15/08/2023`). Multiple formats cause incorrect parsing and failed inserts into `dim_date`.

**Resolution:** All dates were parsed using Python's `dateutil.parser.parse()` and standardized to ISO 8601 (`YYYY-MM-DD`). A numeric `date_id` in `YYYYMMDD` format was derived for efficient indexing and range queries.

---

### Decision 2 — Normalizing Inconsistent Category Casing

**Problem:** The `category` column has five variants for three categories — `electronics`, `Electronics`, `Grocery`, `Groceries`, `Clothing` — causing `GROUP BY category` to produce 5 groups instead of 3 and splitting revenue totals incorrectly.

**Resolution:** All values were converted to Title Case via `str.title()`, then `'Grocery'` was mapped to `'Groceries'`. The three canonical labels loaded into `dim_product` are `Electronics`, `Clothing`, and `Groceries`.

---

### Decision 3 — Recovering NULL store_city and Deriving store_id

**Problem:** `store_city` is NULL for transactions TXN5033, TXN5044, TXN5082, TXN5094, TXN5098 (and others), breaking the foreign key to `dim_store`. Additionally, the raw file has no `store_id` column — only `store_name`.

**Resolution:** Missing cities were recovered by mapping from `store_name` (e.g., `'Mumbai Central'` → `'Mumbai'`). Store IDs were derived using a fixed mapping: `Chennai Anna → S01`, `Delhi South → S02`, `Bangalore MG → S03`, `Pune FC Road → S04`, `Mumbai Central → S05`. Both fixes were applied across all 300 rows before loading into `fact_sales`.

