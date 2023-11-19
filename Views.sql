/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03 (15:00h - 17:00h)
 *		Nome Aluno: Ricardo Pinto (nº 202200637)
 *		Nome Aluno: Rodrigo Maduro (nº 202200166)
 *	    Nome Aluno: Rodrigo Arraiado (nº 202100436)
 *	
 *			Views
 ********************************************/

-- Section: Views

USE AdventureWorks;


-- Drop the CustomerTotalPurchases view
DROP VIEW IF EXISTS Sales.CustomerTotalPurchases;
GO

-- Drop the CustomerPurchases view
DROP VIEW IF EXISTS Sales.CustomerPurchases;
GO




-- View: CustomerPurchases
CREATE VIEW Sales.CustomerPurchases AS
SELECT
    so.SalesOrderNumber,
    so.OrderDate,
    sod.ProductKey,
    p.Size,
    p.Color,
    p.StandardCost,
    p.ListPrice,
    sod.OrderQuantity,
    sod.SalesAmount,
	c.CustomerKey
FROM
    Sales.SalesOrderHeader so
JOIN
    Sales.SalesOrderDetail sod ON so.SalesOrderNumber = sod.SalesOrderNumber
JOIN
    Production.Product p ON sod.ProductKey = p.ProductKey
JOIN
    Person.Customer c ON so.CustomerKey = c.CustomerKey;

GO


-- View: CustomerTotalPurchases
CREATE VIEW Sales.CustomerTotalPurchases AS
SELECT
    cp.SalesOrderNumber,
    cp.OrderDate,
    cp.ProductKey,
    cp.Size,
    cp.Color,
    cp.StandardCost,
    cp.ListPrice,
    cp.OrderQuantity,
    cp.SalesAmount,
    SUM(cp.SalesAmount) OVER (PARTITION BY cp.SalesOrderNumber) AS TotalAmount,
	 cp.CustomerKey 
FROM
    Sales.CustomerPurchases cp;
GO



-- View data for a specific customer
SELECT *
FROM Sales.CustomerTotalPurchases
WHERE CustomerKey = 11237;


-- View data from CustomerPurchases
SELECT *
FROM Sales.CustomerPurchases;
