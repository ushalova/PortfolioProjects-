/* Target E-commerce Data Exploration */

-- Select all columns from the E-commerce sales table
SELECT *
FROM ECommerceDB..Sales
ORDER BY 3,4;


-- Select data to start with, including product, date, sales, and customer information
SELECT ProductName, OrderDate, SalesAmount, CustomerName
FROM ECommerceDB..Sales
ORDER BY 1,2;


-- Calculate the revenue generated by each product
SELECT ProductName, SUM(SalesAmount) AS TotalRevenue
FROM ECommerceDB..Sales
GROUP BY ProductName
ORDER BY TotalRevenue DESC;


-- Calculate the total revenue and total quantity sold for each category
SELECT Category, SUM(SalesAmount) AS TotalRevenue, SUM(Quantity) AS TotalQuantitySold
FROM ECommerceDB..Sales
GROUP BY Category
ORDER BY TotalRevenue DESC;


-- Identify the top-selling products in terms of quantity sold
SELECT ProductName, SUM(Quantity) AS TotalQuantitySold
FROM ECommerceDB..Sales
GROUP BY ProductName
ORDER BY TotalQuantitySold DESC;


-- Identify the top-spending customers
SELECT CustomerName, SUM(SalesAmount) AS TotalSpending
FROM ECommerceDB..Sales
GROUP BY CustomerName
ORDER BY TotalSpending DESC;


-- Show the sales performance over time with a rolling total
SELECT ProductName, OrderDate, SalesAmount, 
       SUM(SalesAmount) OVER (PARTITION BY ProductName ORDER BY OrderDate) AS RollingTotalSales
FROM ECommerceDB..Sales
ORDER BY ProductName, OrderDate;


-- Calculate the average order value (AOV)
SELECT OrderID, AVG(SalesAmount) AS AverageOrderValue
FROM ECommerceDB..Sales
GROUP BY OrderID
ORDER BY AverageOrderValue DESC;


-- Identify the top categories with the highest average sales per order
SELECT Category, AVG(SalesAmount) AS AverageSalesPerOrder
FROM ECommerceDB..Sales
GROUP BY Category
ORDER BY AverageSalesPerOrder DESC;


-- Identify the customers who made the largest single purchase
SELECT CustomerName, MAX(SalesAmount) AS LargestSinglePurchase
FROM ECommerceDB..Sales
GROUP BY CustomerName
ORDER BY LargestSinglePurchase DESC;


-- Calculate the conversion rate for each product category
SELECT Category, 
       SUM(CASE WHEN Quantity > 0 THEN 1 ELSE 0 END) / COUNT(*) AS ConversionRate
FROM ECommerceDB..Sales
GROUP BY Category
ORDER BY ConversionRate DESC;


-- Calculate the percentage of sales contributed by each product to the total sales
SELECT ProductName, SalesAmount, 
       SalesAmount / SUM(SalesAmount) OVER () * 100 AS PercentageOfTotalSales
FROM ECommerceDB..Sales
ORDER BY PercentageOfTotalSales DESC;


-- Identify the products with the highest increase in sales compared to the previous day
WITH SalesComparison AS (
    SELECT ProductName, OrderDate, SalesAmount,
           LAG(SalesAmount) OVER (PARTITION BY ProductName ORDER BY OrderDate) AS PreviousDaySales
    FROM ECommerceDB..Sales
)
SELECT ProductName, OrderDate, SalesAmount, 
       SalesAmount - PreviousDaySales AS SalesIncrease
FROM SalesComparison
ORDER BY ProductName, OrderDate;


-- Calculate the average sales growth rate for each product category
WITH SalesGrowth AS (
    SELECT Category, OrderDate, 
           AVG(SalesAmount) OVER (PARTITION BY Category ORDER BY OrderDate) AS AverageSales
    FROM ECommerceDB..Sales
)
SELECT Category, OrderDate, AverageSales,
       (SalesAmount - AverageSales) / AverageSales * 100 AS SalesGrowthRate
FROM SalesGrowth
ORDER BY Category, OrderDate;
