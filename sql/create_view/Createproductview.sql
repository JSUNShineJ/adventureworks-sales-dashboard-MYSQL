CREATE OR REPLACE VIEW vw_product_details AS
SELECT
    p.ProductKey,
    p.ProductSKU,
    p.ProductName,
    p.ModelName,
    p.ProductDescription,
    p.ProductColor,
    p.ProductSize,
    p.ProductStyle,
    p.ProductCost,
    p.ProductPrice,
    ps.ProductSubcategoryKey,
    ps.SubcategoryName,
    pc.ProductCategoryKey,
    pc.CategoryName
FROM products p
LEFT JOIN product_subcategories ps
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN product_categories pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey;
    
#Check if product attributes support the reporting requirements

SELECT 
    ProductSize,
    COUNT(*)                                    AS product_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct
FROM products
GROUP BY ProductSize
ORDER BY product_count DESC;

SELECT 
    ProductStyle,
    COUNT(*)                                    AS product_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct
FROM products
GROUP BY ProductStyle
ORDER BY product_count DESC;

SELECT 
    ProductColor,
    COUNT(*)                                    AS product_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS pct
FROM products
GROUP BY ProductColor
ORDER BY product_count DESC;