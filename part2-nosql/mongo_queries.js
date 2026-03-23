// ============================================================
// Part 2.2: MongoDB Operations

// Database: ecommerce | Collection: products
// ============================================================

// First: select the database
use ecommerce;

// OP1: insertMany() --- insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    "_id": "ELEC001",
    "category": "Electronics",
    "product_name": "Samsung Galaxy S24 Ultra",
    "brand": "Samsung",
    "price": 134999,
    "currency": "INR",
    "in_stock": true,
    "stock_quantity": 45,
    "specifications": {
      "display": "6.8 inch Dynamic AMOLED",
      "processor": "Snapdragon 8 Gen 3",
      "ram_gb": 12,
      "storage_gb": 256,
      "battery_mah": 5000,
      "camera_mp": 200,
      "voltage": "5V/45W",
      "warranty_years": 1
    },
    "supported_regions": ["India", "UAE", "Singapore"],
    "tags": ["smartphone", "flagship", "android", "5G"],
    "ratings": { "average": 4.6, "total_reviews": 1842 },
    "added_date": "2024-01-15"
  },
  {
    "_id": "CLTH001",
    "category": "Clothing",
    "product_name": "Levi's 511 Slim Fit Jeans",
    "brand": "Levi's",
    "price": 3499,
    "currency": "INR",
    "in_stock": true,
    "stock_quantity": 120,
    "specifications": {
      "material": "98% Cotton, 2% Elastane",
      "fit_type": "Slim Fit",
      "care_instructions": ["Machine wash cold", "Do not bleach", "Tumble dry low"],
      "available_sizes": ["28", "30", "32", "34", "36", "38"],
      "available_colors": ["Dark Indigo", "Stone Wash", "Black", "Light Blue"],
      "country_of_origin": "India"
    },
    "gender": "Men",
    "tags": ["jeans", "denim", "casual", "slim-fit"],
    "ratings": { "average": 4.3, "total_reviews": 5621 },
    "added_date": "2023-09-01"
  },
  {
    "_id": "GROC001",
    "category": "Groceries",
    "product_name": "Organic Toor Dal",
    "brand": "24 Mantra Organic",
    "price": 249,
    "currency": "INR",
    "in_stock": true,
    "stock_quantity": 300,
    "specifications": {
      "weight_kg": 1,
      "organic_certified": true,
      "expiry_date": "2025-12-01",
      "storage_instructions": "Store in a cool, dry place"
    },
    "nutritional_info": {
      "serving_size_g": 100,
      "calories": 343,
      "protein_g": 22,
      "carbohydrates_g": 63,
      "fat_g": 1.5,
      "fiber_g": 15
    },
    "allergens": [],
    "tags": ["dal", "lentils", "organic", "protein", "pulses"],
    "ratings": { "average": 4.5, "total_reviews": 2310 },
    "added_date": "2024-03-10"
  }
]);

// OP2: find() --- retrieve all Electronics products with price > 20000
db.products.find(
  { category: "Electronics", price: { $gt: 20000 } },
  { product_name: 1, price: 1, brand: 1, _id: 0 }
);

// OP3: find() --- retrieve all Groceries expiring before 2025-01-01
db.products.find(
  {
    category: "Groceries",
    "specifications.expiry_date": { $lt: "2025-01-01" }
  },
  { product_name: 1, "specifications.expiry_date": 1, _id: 0 }
);

// OP4: updateOne() --- add a "discount_percent" field to a specific product
db.products.updateOne(
  { _id: "ELEC001" },
  { $set: { discount_percent: 10 } }
);

// OP5: createIndex() --- create an index on category field and explain why
db.products.createIndex({ category: 1 });
/*
  WHY: The e-commerce platform most frequently filters products by category
  (e.g., "show all Electronics", "browse Groceries"). Without an index,
  MongoDB performs a full collection scan (O(n)) on every such query.
  A single-field ascending index on `category` allows MongoDB to use a
  B-tree index scan (O(log n)), dramatically reducing query time as the
  product catalog grows to millions of documents. This index directly
  accelerates OP2 and OP3 above.
*/

// Verify the index was created:
db.products.getIndexes();
