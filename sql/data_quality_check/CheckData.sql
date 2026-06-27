-- ================================================
-- 05_data_quality/audit.sql
-- Purpose: Data Quality Audit for AdventureWorks
-- Covers:  NULL values, duplicates, orphan records,
--          anomalies, and view integrity
-- ================================================

USE adventureworks;

-- ================================================
-- 1. Row Count Summary Across All Tables
-- ================================================
SELECT 'sales_total'                     AS table_name, COUNT(*) AS row_count FROM sales_total
UNION ALL
SELECT 'adventureworks_customers',                      COUNT(*) FROM customers
UNION ALL
SELECT 'adventureworks_products',                       COUNT(*) FROM products
UNION ALL
SELECT 'adventureworks_product_subcategories',          COUNT(*) FROM product_subcategories
UNION ALL
SELECT 'adventureworks_product_categories',             COUNT(*) FROM product_categories
UNION ALL
SELECT 'adventureworks_territories',                    COUNT(*) FROM territories
UNION ALL
SELECT 'adventureworks_returns',                        COUNT(*) FROM returns;

-- ================================================
-- 2. NULL Value Check on sales_total
--    All key fields should have zero NULLs
-- ================================================
SELECT
    SUM(OrderDate     IS NULL) AS null_OrderDate,
    SUM(OrderNumber   IS NULL) AS null_OrderNumber,
    SUM(ProductKey    IS NULL) AS null_ProductKey,
    SUM(CustomerKey   IS NULL) AS null_CustomerKey,
    SUM(TerritoryKey  IS NULL) AS null_TerritoryKey,
    SUM(OrderQuantity IS NULL) AS null_OrderQuantity
FROM sales_total;

-- ================================================
-- 3. Duplicate Order Line Check
--    Same OrderNumber + ProductKey should not
--    appear more than once
-- ================================================
SELECT
    OrderNumber,
    ProductKey,
    COUNT(*) AS duplicate_count
FROM sales_total
GROUP BY OrderNumber, ProductKey
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 20;

-- ================================================
-- 4. Orphan Check: ProductKey in sales_total
--    not found in products table
-- ================================================
SELECT DISTINCT s.ProductKey
FROM sales_total s
LEFT JOIN products p
    ON s.ProductKey = p.ProductKey
WHERE p.ProductKey IS NULL;

-- ================================================
-- 5. Orphan Check: TerritoryKey in sales_total
--    not found in territories table
-- ================================================
SELECT DISTINCT s.TerritoryKey
FROM sales_total s
LEFT JOIN territories t
    ON s.TerritoryKey = t.SalesTerritoryKey
WHERE t.SalesTerritoryKey IS NULL;

-- ================================================
-- 6. Orphan Check: CustomerKey in sales_total
--    not found in customers table
-- ================================================
SELECT DISTINCT s.CustomerKey
FROM sales_total s
LEFT JOIN customers c
    ON s.CustomerKey = c.CustomerKey
WHERE c.CustomerKey IS NULL;

-- ================================================
-- 7. Product Price Anomaly Check
--    Flag records where price <= 0 or
--    cost >= price (negative margin)
-- ================================================
SELECT
    ProductKey,
    ProductName,
    ProductCost,
    ProductPrice
FROM products
WHERE ProductPrice <= 0
   OR ProductCost  <= 0
   OR ProductCost  >= ProductPrice;

-- ================================================
-- 8. Order Quantity Anomaly Check
--    Quantity should always be positive
-- ================================================
SELECT
    OrderNumber,
    ProductKey,
    OrderQuantity
FROM sales_total
WHERE OrderQuantity <= 0;

-- ================================================
-- 9. Date Range Validation
--    Confirm OrderDate falls within expected
--    range (2015-01 to 2017-06)
-- ================================================
SELECT
    MIN(OrderDate) AS earliest_order,
    MAX(OrderDate) AS latest_order,
    COUNT(DISTINCT YEAR(OrderDate))                  AS years_covered,
    COUNT(DISTINCT DATE_FORMAT(OrderDate, '%Y-%m'))  AS months_covered
FROM sales_total;

-- ================================================
-- 10. Territory Sparsity Check
--     Identify low-activity regions by year
--     Note: Central and Northeast confirmed as
--     emerging markets with limited data
-- ================================================
SELECT
    t.Region,
    t.Country,
    t.Continent,
    YEAR(s.OrderDate)              AS order_year,
    COUNT(DISTINCT s.OrderNumber)  AS order_count,
    ROUND(SUM(s.OrderQuantity * p.ProductPrice), 0) AS revenue
FROM sales_total s
LEFT JOIN territories t
    ON s.TerritoryKey = t.SalesTerritoryKey
LEFT JOIN products p
    ON s.ProductKey = p.ProductKey
GROUP BY t.Region, t.Country, t.Continent, YEAR(s.OrderDate)
ORDER BY t.Region, order_year;

-- ================================================
-- 11. AnnualIncome Cleaning Validation
--     Confirm no residual $ signs or commas
--     remain after cleaning step
-- ================================================
SELECT COUNT(*) AS unclean_rows
FROM customers
WHERE AnnualIncome LIKE '%$%'
   OR AnnualIncome LIKE '%,%';

-- ================================================
-- 12. vw_sales_detail View Integrity Check
--     Row count must match sales_total
--     All dimension fields should be non-NULL
--     Revenue and Profit should be positive
-- ================================================
SELECT
    COUNT(*)                   AS total_rows,
    SUM(Region      IS NULL)   AS null_region,
    SUM(Country     IS NULL)   AS null_country,
    SUM(ProductName IS NULL)   AS null_product,
    SUM(CategoryName IS NULL)  AS null_category,
    SUM(Revenue     IS NULL)   AS null_revenue,
    SUM(Profit      IS NULL)   AS null_profit,
    SUM(Revenue < 0)           AS negative_revenue,
    SUM(Profit  < 0)           AS negative_profit
FROM vw_sales_detail;