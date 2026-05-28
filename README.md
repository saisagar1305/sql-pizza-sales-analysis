# 🍕 Pizza Sales SQL Analysis Project

## Project Overview

This project performs an end-to-end SQL analysis of a pizza restaurant's sales data for the year **2015**. Starting from raw transactional data, the project covers data cleaning, KPI reporting, time-series trend analysis, product performance, and advanced analytics using subqueries and window functions.

---

## Dataset

| Attribute | Details |
|---|---|
| **File** | `pizza_sales.csv` |
| **Time Period** | January 1, 2015 – December 31, 2015 |
| **Total Records** | 48,620 rows |
| **Unique Pizzas** | 32 |
| **Categories** | Classic, Veggie, Supreme, Chicken |
| **Sizes** | S, M, L, XL, XXL |
| **Total Revenue** | ~$817,860 |

### Schema

```sql
CREATE TABLE pizza_sales (
    pizza_id         INT PRIMARY KEY,
    order_id         INT,
    pizza_name_id    VARCHAR(255),
    quantity         INT,
    order_date       DATE,
    order_time       TIME,
    unit_price       DECIMAL(10,2),
    total_price      DECIMAL(10,2),
    pizza_size       VARCHAR(10),
    pizza_category   VARCHAR(50),
    pizza_ingredients VARCHAR(1000),
    pizza_name       VARCHAR(255)
);
```

---

## Tools & Environment

- **Database:** MySQL 8.0
- **Data Loading:** `LOAD DATA INFILE` with `secure_file_priv` configuration
- **Language:** SQL (DDL + DML + Analytical Queries)

---

## Project Structure

```
pizza-sales-analysis/
│
├── pizza_sales.csv              # Raw transactional data
├── pizza_sales_analysis.sql     # Full SQL script (cleaning + all queries)
└── README.md                    # Project documentation
```

---

## Analysis Breakdown

### 🔧 Data Hardening (Cleaning & Transformation)

Before any analysis, the raw data was cleaned and standardized:

| Step | Action |
|---|---|
| Fix Date Format | Converted `order_date` from `DD-MM-YYYY` string → `DATE` using `STR_TO_DATE()` |
| Fix Time Format | Replaced `.` separators in `order_time` with `:` → cast to `TIME` |

---

### 📊 Phase 1: High-Level Sales KPIs

| # | Question | SQL Concept Used |
|---|---|---|
| Q1 | Total Revenue | `SUM(total_price)` |
| Q2 | Average Order Value | `SUM / COUNT(DISTINCT order_id)` |
| Q3 | Total Pizzas Sold | `SUM(quantity)` |
| Q4 | Total Orders | `COUNT(DISTINCT order_id)` |
| Q5 | Average Pizzas Per Order | `SUM(quantity) / COUNT(DISTINCT order_id)` |

---

### 📈 Phase 2: Time-Series Analysis

| # | Question | SQL Concept Used |
|---|---|---|
| Q6 | Hourly Sales Trend | `HOUR(order_time)`, `GROUP BY` |
| Q7 | Weekly Sales Trend | `DAYNAME(order_date)`, `GROUP BY` |
| Q8 | Monthly Revenue | `MONTHNAME(order_date)`, `GROUP BY` |
| Q9 | Weekend vs Weekday | `CASE WHEN DAYOFWEEK() IN (1,7)`, conditional aggregation |

---

### 🍕 Phase 3: Product & Menu Engineering

| # | Question | SQL Concept Used |
|---|---|---|
| Q10 | Revenue by Category (value & % of total) | `GROUP BY pizza_category`, correlated subquery for % |
| Q11 | Revenue by Pizza Size (value & % of total) | `GROUP BY pizza_size`, correlated subquery for % |

---

### 🔍 Phase 4: Advanced Analysis

| # | Question | SQL Concept Used |
|---|---|---|
| Q12 | Top 5 Best Sellers by Revenue | `ORDER BY revenue DESC LIMIT 5` |
| Q13 | Bottom 5 Worst Sellers by Revenue | `ORDER BY revenue ASC LIMIT 5` |
| Q14 | Do people order larger pizzas on weekends? | `CASE WHEN DAYOFWEEK() IN (1,7)`, conditional `SUM` |
| Q15 | Best-selling category during Peak Hours | `HOUR(order_time)` + `pizza_category`, `GROUP BY` combo |
| Q16 | Category Leaders | CTE + `RANK() OVER (PARTITION BY pizza_category)` |

---

## Key SQL Techniques Demonstrated

- **Data Cleaning:** `STR_TO_DATE()`, `REPLACE()`, `ALTER TABLE ... MODIFY COLUMN`
- **Aggregations:** `SUM()`, `COUNT(DISTINCT ...)`, `AVG()`
- **Date & Time Functions:** `HOUR()`, `DAYNAME()`, `MONTHNAME()`, `DAYOFWEEK()`, `DAY()`
- **Conditional Logic:** `CASE WHEN ... THEN ... END`
- **Subqueries:** Correlated subqueries for percentage-of-total calculations
- **CTEs:** `WITH ... AS (...)` for readable multi-step logic
- **Window Functions:** `RANK() OVER (PARTITION BY ... ORDER BY ...)`

---

## How to Run

1. Start MySQL 8.0 and verify the `secure_file_priv` path:
   ```sql
   SHOW VARIABLES LIKE 'secure_file_priv';
   ```
2. Copy `pizza_sales.csv` to the path returned above (e.g., `C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/`).
3. Open `pizza_sales_analysis.sql` in MySQL Workbench (or any MySQL client).
4. Run the script top to bottom — it will:
   - Create the `pizza_db` database
   - Create the `pizza_sales` table
   - Load and clean the data
   - Execute all analytical queries

---

## Author

Developed as a self-driven SQL analytics project to practice real-world data cleaning, KPI reporting, trend analysis, and advanced SQL using a pizza restaurant dataset.
