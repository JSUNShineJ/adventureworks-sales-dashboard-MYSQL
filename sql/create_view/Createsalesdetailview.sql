USE adventureworks;

CREATE OR REPLACE VIEW vw_sales_detail AS
SELECT
    s.OrderDate,
    s.OrderNumber,
    t.Region,
    t.Country,
    t.Continent,
    p.ModelName,
    p.ProductName,
    p.SubcategoryName,
    p.CategoryName,
    p.ProductColor,
	p.ProductSize,
	p.ProductStyle,
    s.OrderQuantity,
    p.ProductPrice,
    p.ProductCost,
    Round(s.OrderQuantity * p.ProductPrice,2)                  AS Revenue,
    Round(s.OrderQuantity * (p.ProductPrice - p.ProductCost),2)  AS Profit,
    Case 
		When p.ProductPrice = 0 THEN NULL
        Else 
			(p.ProductPrice - p.ProductCost)/p.ProductPrice
	End AS ProfitMargin
    
FROM sales_total s
LEFT JOIN vw_product_details p
    ON s.ProductKey = p.ProductKey
LEFT JOIN territories t
    ON s.TerritoryKey = t.SalesTerritoryKey;
    
-- 1. 行数应和 sales_total 一致
SELECT COUNT(*) FROM vw_sales_detail;

-- 2. 抽查内容
SELECT * FROM vw_sales_detail LIMIT 10;

-- 3. 各品类利润率(第一个真实业务查询)
SELECT
    CategoryName,
    ROUND(SUM(Revenue), 0)                          AS Total_Revenue,
    ROUND(SUM(Profit), 0)                           AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Revenue)*100, 1)          AS Profit_Margin_Pct
FROM vw_sales_detail
GROUP BY CategoryName
ORDER BY Total_Revenue DESC;
-- 4. export data into csv
SELECT * FROM vw_sales_detail;
