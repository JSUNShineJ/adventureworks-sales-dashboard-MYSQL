USE adventureworks;
#Import Sales table as Import Waziard is slow on importing Large dataset
DROP TABLE IF EXISTS sales_2017;
DROP TABLE IF EXISTS sales_2016;
DROP TABLE IF EXISTS sales_2015;

CREATE TABLE sales_2017 (
    OrderDate       VARCHAR(20),  
    StockDate       VARCHAR(20),   
    OrderNumber     VARCHAR(20),  
    ProductKey      INT,         
    CustomerKey     INT,         
    TerritoryKey    INT,
    OrderLineItem   INT,
    OrderQuantity   INT
);
LOAD DATA LOCAL INFILE 'localpath-2017' -- modify it to local path
INTO TABLE sales_2017
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;USE adventureworks;

CREATE TABLE sales_2016 (
    OrderDate       VARCHAR(20),   
    StockDate       VARCHAR(20),   
    OrderNumber     VARCHAR(20),   
    ProductKey      INT,           
    CustomerKey     INT,           
    TerritoryKey    INT,           
    OrderLineItem   INT,
    OrderQuantity   INT
);
LOAD DATA LOCAL INFILE 'localpath-2017' -- modify it to local path
INTO TABLE sales_2016
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE sales_2015 (
    OrderDate       VARCHAR(20),   
    StockDate       VARCHAR(20),   
    OrderNumber     VARCHAR(20),   
    ProductKey      INT,          
    CustomerKey     INT,           
    TerritoryKey    INT,           
    OrderLineItem   INT,
    OrderQuantity   INT
);
LOAD DATA LOCAL INFILE 'localpath-2017'  -- modify it to local path
INTO TABLE sales_2015
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


#Union 3 Yearly-Sales table into One 
DROP TABLE IF EXISTS sales_total;

CREATE TABLE sales_total AS
SELECT * FROM sales_2015

UNION ALL

SELECT * FROM sales_2016

UNION ALL

SELECT * FROM sales_2017;


#Correct Date data into Date type
SET SQL_SAFE_UPDATES = 0;
UPDATE sales_total
SET OrderDate = STR_TO_DATE(OrderDate, '%c/%e/%Y') #c-mouth,e-day,y-year
WHERE CAST(OrderDate AS CHAR) LIKE '%/%';

UPDATE sales_total
SET StockDate = STR_TO_DATE(StockDate, '%c/%e/%Y')
WHERE CAST(StockDate AS CHAR) LIKE '%/%';

UPDATE calendar
SET DateKey = STR_TO_DATE(DateKey, '%c/%e/%Y')
WHERE CAST(DateKey AS CHAR) LIKE '%/%';

UPDATE customers
SET BirthDate = STR_TO_DATE(BirthDate, '%c/%e/%Y') #c-mouth,e-day,y-year
WHERE CAST(BirthDate AS CHAR) LIKE '%/%';

UPDATE returnInfo
SET ReturnDate = STR_TO_DATE(ReturnDate, '%c/%e/%Y') #c-mouth,e-day,y-year
WHERE CAST(ReturnDate AS CHAR) LIKE '%/%';

ALTER TABLE sales_total
MODIFY COLUMN OrderDate DATE;

ALTER TABLE sales_total
MODIFY COLUMN StockDate DATE;

ALTER TABLE calendar
MODIFY COLUMN DateKey DATE;

ALTER TABLE customers
MODIFY COLUMN BirthDate DATE;

ALTER TABLE returnInfo
MODIFY COLUMN ReturnDate DATE;

SET SQL_SAFE_UPDATES = 1;


#Add numeric AnnualIncome for better calculate
ALTER TABLE customers
ADD COLUMN AnnualIncome_numeric INT;

SET SQL_SAFE_UPDATES = 0;
UPDATE customers
SET AnnualIncome_numeric = CAST(replace(replace(AnnualIncome,'$',''),',','') AS unsigned)
WHERE AnnualIncome IS NOT NULL
AND TRIM(AnnualIncome) <> '';
SET SQL_SAFE_UPDATES = 1;
