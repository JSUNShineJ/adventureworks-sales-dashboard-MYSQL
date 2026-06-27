#For each OrderNumber that appears more than three times, 
#return the first two records ordered by ProductKey, with a maximum of 10 rows in total.
With RankSales AS(
	Select s.*,
			Row_number() Over( partition by s.OrderNumber Order by ProductKey) AS RowNum,
			Count(*) Over(partition by s.OrderNumber) AS duplicatetime
	From sales_total As s
)

Select *
From RankSales
Where RowNum < 3
	AND duplicatetime > 3
Limit 10;


#Check duplicated ProductKey
Select ProductKey, Count(*) As Duplictetime , Sum(ReturnQuantity) As totalreturnQuantity
From returnInfo
group by ProductKey
Having Duplictetime > 1
Order by ProductKey Asc;


/*
SELECT
	'sales_total' As tablename,
    OrderNumber As key1,
    OrderLineItem As key2,
    COUNT(*)
FROM sales_total
GROUP BY OrderNumber, OrderLineItem
HAVING COUNT(*) > 1

Union All

SELECT
	'returnInfo' As tablename,
    TerritoryKey As key1,
    ProductKey As key2,
    COUNT(*)
FROM returnInfo
GROUP BY TerritoryKey, ProductKey
HAVING COUNT(*) > 1;
*/

# add duplicate primary key
ALTER TABLE sales_total
ADD PRIMARY KEY (OrderNumber,OrderLineItem);

