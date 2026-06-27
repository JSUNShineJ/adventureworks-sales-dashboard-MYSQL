# Check Primary Key
/*
SELECT
	'calendar' AS TableName,
    'DateKey' AS PrimaryKey,
    if(Count(*) = Count(DISTINCT DateKey),'True','FALSE') AS ISPrimary,
    SUM(DateKey IS NULL) AS NullKeys
FROM calendar

Union All

SELECT
	'customers' AS TableName,
    'CustomerKey' AS PrimaryKey,
    if(Count(*) = Count(DISTINCT CustomerKey),'True','FALSE') AS ISPrimary,
    SUM(CustomerKey IS NULL) AS NullKeys
FROM customers

Union All

SELECT
	'product_categories' AS TableName,
    'ProductCategoryKey' AS PrimaryKey,
    if(Count(*) = Count(DISTINCT ProductCategoryKey),'True','FALSE') AS ISPrimary,
    SUM(ProductCategoryKey IS NULL) AS NullKeys
FROM product_categories

Union All

SELECT
	'products' AS TableName,
    'ProductKey' AS PrimaryKey,
    if(Count(*) = Count(DISTINCT ProductKey),'True','FALSE') AS ISPrimary,
    SUM(ProductKey IS NULL) AS NullKeys
FROM products

Union All

SELECT
	'product_subcategories' AS TableName,
    'ProductSubcategoryKey' AS PrimaryKey,
    if(Count(*) = Count(DISTINCT ProductSubcategoryKey),'True','FALSE') AS ISPrimary,
    SUM(ProductSubcategoryKey IS NULL) AS NullKeys
FROM product_subcategories

Union All

SELECT 
	'returnInfo' AS TableName,
    'ProductKey' AS PrimaryKey,
    if(Count(*) = Count(DISTINCT ProductKey),'True','FALSE') AS ISPrimary,
    SUM(ProductKey IS NULL) AS NullKeys
FROM returnInfo

Union All

# Key is not OrderNumber?
SELECT
	'sales_total' AS TableName,
    'OrderNumber' AS PrimaryKey,
    if(Count(*) = Count(DISTINCT OrderNumber),'True','FALSE') AS ISPrimary,
    SUM(OrderNumber IS NULL) AS NullKeys
FROM sales_total

Union All

SELECT 
	'territories' AS TableName,
    'SalesTerritoryKey' AS PrimaryKey,
    if(Count(*) = Count(DISTINCT SalesTerritoryKey),'True','FALSE') AS ISPrimary,
    SUM(SalesTerritoryKey IS NULL) AS NullKeys
FROM territories;
*/


#add PRIMARY

ALTER TABLE customers
ADD PRIMARY KEY (CustomerKey);

ALTER TABLE products
ADD PRIMARY KEY (ProductKey);

ALTER TABLE territories
ADD PRIMARY KEY (SalesTerritoryKey);

ALTER TABLE product_subcategories
ADD PRIMARY KEY (ProductSubcategoryKey);

ALTER TABLE product_categories
ADD PRIMARY KEY (ProductCategoryKey);

ALTER TABLE calendar
ADD PRIMARY KEY (DateKey);

