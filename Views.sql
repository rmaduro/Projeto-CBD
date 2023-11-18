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

-- View to display customer details along with address information
USE AdventureWorks;
GO
CREATE VIEW vwCustomerAddress AS
SELECT
    c.CustomerKey,
    c.LastName,
    c.FirstName,
    a.AddressKey,
    a.AddressLine1,
    a.AddressLine2,
    a.City,
    a.StateProvince,
    a.PostalCode,
    a.CountryRegion
FROM
    Person.Customer c
JOIN
    Sales.Address a ON c.CustomerKey = a.CustomerKey;
GO

-- View to show sales order details along with customer and product information
CREATE VIEW vwSalesOrderDetails AS
SELECT
    soh.SalesOrderNumber,
    soh.OrderDate,
    soh.DueDate,
    c.LastName AS CustomerLastName,
    c.FirstName AS CustomerFirstName,
    sod.ProductKey,
    p.Size,
    p.Color,
    sod.OrderQuantity,
    sod.UnitPrice,
    sod.DiscountAmount,
    sod.ExtendedAmount
FROM
    Sales.SalesOrderHeader soh
JOIN
    Person.Customer c ON soh.CustomerKey = c.CustomerKey
JOIN
    Sales.SalesOrderDetail sod ON soh.SalesOrderNumber = sod.SalesOrderNumber
JOIN
    Production.Product p ON sod.ProductKey = p.ProductKey;
GO

-- View to display product details along with category and subcategory information
CREATE VIEW vwProductDetails AS
SELECT
    p.ProductKey,
    p.Size,
    p.Color,
    p.StandardCost,
    p.ListPrice,
    p.Weight,
    p.Class,
    p.ProductLine,
    c.FrenchCategoryName AS CategoryName,
    sc.FrenchSubCategoryName AS SubCategoryName
FROM
    Production.Product p
JOIN
    Production.SubCategory sc ON p.SubCategoryKey = sc.SubCategoryKey
JOIN
    Production.Category c ON sc.CategoryKey = c.CategoryKey;
GO

-- View to show customer order history
CREATE VIEW vwCustomerOrderHistory AS
SELECT
    c.CustomerKey,
    c.LastName,
    c.FirstName,
    soh.SalesOrderNumber,
    soh.OrderDate,
    soh.DueDate,
    sod.ProductKey,
    p.Size,
    p.Color,
    sod.OrderQuantity,
    sod.UnitPrice,
    sod.DiscountAmount,
    sod.ExtendedAmount
FROM
    Person.Customer c
JOIN
    Sales.SalesOrderHeader soh ON c.CustomerKey = soh.CustomerKey
JOIN
    Sales.SalesOrderDetail sod ON soh.SalesOrderNumber = sod.SalesOrderNumber
JOIN
    Production.Product p ON sod.ProductKey = p.ProductKey;
GO

-- View to display sales territory details
CREATE VIEW vwSalesTerritoryDetails AS
SELECT
    st.SalesTerritoryKey,
    st.SalesTerritoryCountry,
    st.SalesTerritoryRegion,
    st.SalesTerritoryGroup
FROM
    Sales.SalesTerritory st;
GO

-- View to display total sales amount per product
CREATE VIEW vwTotalSalesPerProduct AS
SELECT
    p.ProductKey,
    p.Size,
    p.Color,
    SUM(sod.ExtendedAmount) AS TotalSalesAmount
FROM
    Production.Product p
JOIN
    Sales.SalesOrderDetail sod ON p.ProductKey = sod.ProductKey
GROUP BY
    p.ProductKey, p.Size, p.Color;
GO

-- View to show customer contact details along with order information
CREATE VIEW vwCustomerContactOrders AS
SELECT
    c.CustomerKey,
    c.LastName,
    c.FirstName,
    c.EmailAddress,
    soh.SalesOrderNumber,
    soh.OrderDate,
    soh.DueDate,
    sod.ProductKey,
    p.Size,
    p.Color,
    sod.OrderQuantity,
    sod.UnitPrice,
    sod.DiscountAmount,
    sod.ExtendedAmount
FROM
    Person.Customer c
JOIN
    Sales.SalesOrderHeader soh ON c.CustomerKey = soh.CustomerKey
JOIN
    Sales.SalesOrderDetail sod ON soh.SalesOrderNumber = sod.SalesOrderNumber
JOIN
    Production.Product p ON sod.ProductKey = p.ProductKey;
GO

-- View to display product details along with their average sales price
CREATE VIEW vwProductAverageSalesPrice AS
SELECT
    p.ProductKey,
    p.Size,
    p.Color,
    AVG(sod.UnitPrice) AS AverageSalesPrice
FROM
    Production.Product p
JOIN
    Sales.SalesOrderDetail sod ON p.ProductKey = sod.ProductKey
GROUP BY
    p.ProductKey, p.Size, p.Color;
GO

-- View to show sales order details with currency information
CREATE VIEW vwSalesOrderWithCurrency AS
SELECT
    soh.SalesOrderNumber,
    soh.OrderDate,
    soh.DueDate,
    c.LastName AS CustomerLastName,
    c.FirstName AS CustomerFirstName,
    sod.ProductKey,
    p.Size,
    p.Color,
    sod.OrderQuantity,
    sod.UnitPrice,
    sod.DiscountAmount,
    sod.ExtendedAmount,
    cur.CurrencyAlternateKey,
    cur.CurrencyName
FROM
    Sales.SalesOrderHeader soh
JOIN
    Person.Customer c ON soh.CustomerKey = c.CustomerKey
JOIN
    Sales.SalesOrderDetail sod ON soh.SalesOrderNumber = sod.SalesOrderNumber
JOIN
    Production.Product p ON sod.ProductKey = p.ProductKey
JOIN
    Sales.Currency cur ON soh.CurrencyKey = cur.CurrencyKey;
GO

-- View to display customer details along with the total number of orders
CREATE VIEW vwCustomerTotalOrders AS
SELECT
    c.CustomerKey,
    c.LastName,
    c.FirstName,
    COUNT(soh.SalesOrderNumber) AS TotalOrders
FROM
    Person.Customer c
LEFT JOIN
    Sales.SalesOrderHeader soh ON c.CustomerKey = soh.CustomerKey
GROUP BY
    c.CustomerKey, c.LastName, c.FirstName;
GO




-- Section: Select Statements

-- Query the vwCustomerAddress view to retrieve customer and address details
SELECT * FROM vwCustomerAddress;
GO

-- Query the vwSalesOrderDetails view to retrieve sales order details
SELECT * FROM vwSalesOrderDetails;
GO

-- Query the vwProductDetails view to retrieve product details along with category and subcategory information
SELECT * FROM vwProductDetails;
GO

-- Query the vwCustomerOrderHistory view to retrieve customer order history
SELECT * FROM vwCustomerOrderHistory;
GO

-- Query the vwSalesTerritoryDetails view to retrieve sales territory details
SELECT * FROM vwSalesTerritoryDetails;
GO

-- Query the vwCustomerAddress view to retrieve customer and address details
SELECT * FROM vwCustomerAddress;
GO

-- Query the vwSalesOrderDetails view to retrieve sales order details
SELECT * FROM vwSalesOrderDetails;
GO

-- Query the vwTotalSalesPerProduct view to retrieve total sales per product
SELECT * FROM vwTotalSalesPerProduct;
GO

-- Query the vwCustomerContactOrders view to retrieve customer contact details along with order information
SELECT * FROM vwCustomerContactOrders;
GO

-- Query the vwProductAverageSalesPrice view to retrieve product details along with their average sales price
SELECT * FROM vwProductAverageSalesPrice;
GO

-- Query the vwSalesOrderWithCurrency view to retrieve sales order details with currency information
SELECT * FROM vwSalesOrderWithCurrency;
GO

-- Query the vwCustomerTotalOrders view to retrieve customer details along with the total number of orders
SELECT * FROM vwCustomerTotalOrders;
GO
