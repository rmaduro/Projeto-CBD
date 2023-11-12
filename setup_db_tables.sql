-- Drop the AdventureWorks database if it exists
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'AdventureWorks')
    DROP DATABASE AdventureWorks;
GO

-- Create the AdventureWorks database if it does not exist
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'AdventureWorks')
    CREATE DATABASE AdventureWorks;
GO

USE AdventureWorks;

-- Drop the schemas if they exist
DROP SCHEMA IF EXISTS Sales
GO
DROP SCHEMA IF EXISTS Production
GO

-- Create the Sales schema
CREATE SCHEMA Sales;
GO

-- Create the Production schema
CREATE SCHEMA Production;
GO

-- Drop the tables if they exist
DROP TABLE IF EXISTS Sales.SalesOrderDetail;
DROP TABLE IF EXISTS Production.Product;
DROP TABLE IF EXISTS Production.Description;
DROP TABLE IF EXISTS Sales.SalesOrderHeader;
DROP TABLE IF EXISTS Sales.Customer;
DROP TABLE IF EXISTS Sales.Address;
DROP TABLE IF EXISTS Sales.CustomerAddress;
DROP TABLE IF EXISTS Sales.SalesTerritory;
DROP TABLE IF EXISTS Sales.Currency;
DROP TABLE IF EXISTS Production.SubCategory;
DROP TABLE IF EXISTS Production.Category;

-- Category Table
CREATE TABLE Production.Category (
  CategoryKey INT IDENTITY(1,1) PRIMARY KEY,
  FrenchCategoryName VARCHAR(50),
  EnglishCategoryName VARCHAR(50),
  SpanishCategoryName VARCHAR(50)
);

-- SubCategory Table
CREATE TABLE Production.SubCategory (
  SubCategoryKey INT IDENTITY(1,1) PRIMARY KEY,
  FrenchSubCategoryName VARCHAR(50),
  EnglishSubCategoryName VARCHAR(50),
  SpanishSubCategoryName VARCHAR(50),
  CategoryKey INT,
  FOREIGN KEY (CategoryKey) REFERENCES Production.Category(CategoryKey)
);

-- Currency Table
CREATE TABLE Sales.Currency (
  CurrencyKey TINYINT IDENTITY(1,1) PRIMARY KEY,
  CurrencyAlternateKey VARCHAR(50),
  CurrencyName VARCHAR(50)
);

-- SalesTerritory Table
CREATE TABLE Sales.SalesTerritory (
  SalesTerritoryKey INT IDENTITY(1,1) PRIMARY KEY,
  SalesTerritoryCountry VARCHAR(255),
  SalesTerritoryRegion VARCHAR(255),
  SalesTerritoryGroup VARCHAR(255)
);

-- Address Table
CREATE TABLE Sales.Address (
  AddressKey INT IDENTITY(1,1) PRIMARY KEY,
  StateProvince VARCHAR(50),
  CountryRegion VARCHAR(50),
  City VARCHAR(50),
  AddressLine2 VARCHAR(255),
  AddressLine1 VARCHAR(255),
  PostalCode Varchar(50),
  StateProvinceName VARCHAR(255),
  CountryRegionName VARCHAR(255),
  SalesTerritoryKey INT,
  FOREIGN KEY (SalesTerritoryKey) REFERENCES Sales.SalesTerritory(SalesTerritoryKey),
);

-- Customer Table
CREATE TABLE Sales.Customer (
  CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
  LastName VARCHAR(255),
  MiddleName VARCHAR(50),
  FirstName VARCHAR(50),
  NameStyle VARCHAR(50),
  BirthDate DATE,
  MaritalStatus VARCHAR(50),
  Gender VARCHAR(50),
  EmailAddress VARCHAR(50),
  YearlyIncome INT,
  Title VARCHAR(10),
  TotalChildren TINYINT,
  NumberChildrenAtHome TINYINT,
  EducationLevel VARCHAR(50),
  Occupation VARCHAR(50),
  HouseOwnerFlag BIT,
  NumberCarsOwned TINYINT,
  Phone VARCHAR(50),
  DateFirstPurchase DATE,
  CommuteDistance VARCHAR(50)
);

-- CustomerAddress Table
CREATE TABLE Sales.CustomerAddress (
    CustomerAddressKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerKey INT,
    AddressKey INT,
    CONSTRAINT FK_CustomerAddress_Customer FOREIGN KEY (CustomerKey) REFERENCES Sales.Customer(CustomerKey),
    CONSTRAINT FK_CustomerAddress_Address FOREIGN KEY (AddressKey) REFERENCES Sales.Address(AddressKey)
);

-- SalesOrderHeader Table
CREATE TABLE Sales.SalesOrderHeader (
  SalesOrderNumber VARCHAR(50) PRIMARY KEY,
  DueDate DATE,
  OrderDate DATE,
  CustomerPONumber SMALLINT,
  CarrierTrackingNumber TINYINT,
  OrderDateKey DATE,
  DueDateKey DATE,
  RevisionNumber TINYINT,
  ShipDate DATETIME2(7),
  ShipDateKey DATE,
  CustomerKey INT,
  CurrencyKey TINYINT,
  SalesTerritoryKey INT,
  FOREIGN KEY (CustomerKey) REFERENCES Sales.Customer(CustomerKey),
  FOREIGN KEY (CurrencyKey) REFERENCES Sales.Currency(CurrencyKey),
  FOREIGN KEY (SalesTerritoryKey) REFERENCES Sales.SalesTerritory(SalesTerritoryKey)
);

-- Description Table
CREATE TABLE Production.Description (
  DescriptionKey INT IDENTITY(1,1) PRIMARY KEY,
  FrenchDescription NVARCHAR(1000),
  EnglishDescription NVARCHAR(255),
  SpanishProductName NVARCHAR(255),
  EnglishProductName NVARCHAR(255),
  FrenchProductName NVARCHAR(255)
);

-- Product Table
CREATE TABLE Production.Product (
  ProductKey INT IDENTITY(1,1) PRIMARY KEY,
  Size VARCHAR(50),
  SizeUnitMeasureCode VARCHAR(50),
  DaysToManufacture TINYINT,
  Color VARCHAR(50),
  SizeRange VARCHAR(50),
  StandardCost FLOAT,
  ListPrice FLOAT,
  SafetyStockLevel SMALLINT,
  WeightUnitMeasureCode VARCHAR(50),
  FinishedGoodsFlag VARCHAR(50),
  Weight FLOAT,
  Class VARCHAR(50),
  ProductLine VARCHAR(50),
  DealerPrice FLOAT,
  ModelName VARCHAR(50),
  Status VARCHAR(50),
  DescriptionKey INT,
  SubCategoryKey INT,
  FOREIGN KEY (DescriptionKey) REFERENCES Production.Description(DescriptionKey),
  FOREIGN KEY (SubCategoryKey) REFERENCES Production.SubCategory(SubCategoryKey)
);

-- SalesOrderDetail Table
CREATE TABLE Sales.SalesOrderDetail (
  SalesOrderKey INT IDENTITY(1,1) PRIMARY KEY,
  TaxAmt INT,
  SalesAmount FLOAT,
  SalesOrderLineNumber TINYINT,
  DiscountAmount TINYINT,
  UnitPriceDiscountPct TINYINT,
  OrderQuantity TINYINT,
  ProductStandardCost FLOAT,
  UnitPrice FLOAT,
  TotalProductCost FLOAT,
  ExtendedAmount FLOAT,
  ProductKey INT,
  FOREIGN KEY (ProductKey) REFERENCES Production.Product(ProductKey)
);

-- Data Migration

DROP PROCEDURE IF EXISTS Production.MigrateCategory;
DROP PROCEDURE IF EXISTS Production.MigrateSubCategory;
DROP PROCEDURE IF EXISTS Production.MigrateDescription;
DROP PROCEDURE IF EXISTS Production.MigrateProduct;
DROP PROCEDURE IF EXISTS Sales.MigrateSalesTerritory;
DROP PROCEDURE IF EXISTS Sales.MigrateAddress;
DROP PROCEDURE IF EXISTS Sales.MigrateCurrency;
DROP PROCEDURE IF EXISTS Sales.MigrateCustomer;
DROP PROCEDURE IF EXISTS Sales.MigrateSalesOrderHeader;
DROP PROCEDURE IF EXISTS Sales.MigrateSalesOrderDetail;
DROP PROCEDURE IF EXISTS Sales.MigrateCustomerAddress;
GO

CREATE PROCEDURE Production.MigrateCategory
AS
BEGIN
    INSERT INTO Production.Category (FrenchCategoryName, EnglishCategoryName, SpanishCategoryName)
    SELECT DISTINCT FrenchProductCategoryName, EnglishProductCategoryName, SpanishProductCategoryName
    FROM AdventureWorksOldData.Production.Products 
END;
GO

EXEC Production.MigrateCategory;
GO


CREATE PROCEDURE Production.MigrateSubCategory
AS
BEGIN
	INSERT INTO Production.SubCategory (FrenchSubCategoryName, EnglishSubCategoryName, SpanishSubCategoryName, CategoryKey)
	SELECT DISTINCT s.FrenchProductSubCategoryName, s.EnglishProductSubCategoryName, s.SpanishProductSubCategoryName, c.CategoryKey
	FROM AdventureWorksOldData.Production.ProductSubCategory s
	JOIN AdventureWorksOldData.Production.Products p ON p.ProductSubcategoryKey  = s.ProductSubcategoryKey
	JOIN Production.Category c ON p.EnglishProductCategoryName COLLATE SQL_Latin1_General_CP1_CI_AS = c.EnglishCategoryName COLLATE SQL_Latin1_General_CP1_CI_AS; 
END;
GO

EXEC Production.MigrateSubCategory;
GO

EXEC Production.MigrateCategory;
GO



CREATE PROCEDURE Production.MigrateDescription
AS
BEGIN
    INSERT INTO Production.Description (FrenchDescription, EnglishDescription, SpanishProductName, EnglishProductName, FrenchProductName)
    SELECT DISTINCT FrenchDescription, EnglishDescription, SpanishProductName, EnglishProductName, FrenchProductName
    FROM AdventureWorksOldData.Production.Products;
END;
GO

EXEC Production.MigrateDescription;
GO

SELECT * FROM Production.Description;

DROP PROCEDURE IF EXISTS Production.MigrateProduct
GO

CREATE PROCEDURE Production.MigrateProduct
AS
BEGIN
    INSERT INTO Production.Product (Size, SizeUnitMeasureCode, DaysToManufacture, Color, SizeRange, StandardCost, ListPrice, SafetyStockLevel, WeightUnitMeasureCode, FinishedGoodsFlag, Weight, Class, ProductLine, DealerPrice, ModelName, Status, SubCategoryKey, DescriptionKey)
    SELECT DISTINCT p.Size, p.SizeUnitMeasureCode, p.DaysToManufacture, p.Color, p.SizeRange, p.StandardCost, p.ListPrice, p.SafetyStockLevel, p.WeightUnitMeasureCode, p.FinishedGoodsFlag, p.Weight, p.Class, p.ProductLine, p.DealerPrice, p.ModelName, p.Status, p.ProductSubcategoryKey, d.DescriptionKey
    FROM AdventureWorksOldData.Production.Products p
	JOIN Production.Description d ON p.EnglishProductName COLLATE SQL_Latin1_General_CP1_CI_AS = d.EnglishProductName COLLATE SQL_Latin1_General_CP1_CI_AS;

END;
GO

EXEC Production.MigrateProduct;
GO



CREATE PROCEDURE Sales.MigrateSalesTerritory
AS
BEGIN
    INSERT INTO Sales.SalesTerritory (SalesTerritoryCountry, SalesTerritoryRegion, SalesTerritoryGroup)
    SELECT DISTINCT SalesTerritoryCountry, SalesTerritoryRegion, SalesTerritoryGroup
    FROM AdventureWorksOldData.Sales.SalesTerritory;
END;
GO

EXEC Sales.MigrateSalesTerritory;
GO


CREATE PROCEDURE Sales.MigrateAddress
AS
BEGIN
    INSERT INTO Sales.Address (StateProvince, CountryRegion, City, AddressLine1, AddressLine2, PostalCode, StateProvinceName, CountryRegionName, SalesTerritoryKey)
    SELECT DISTINCT  a.StateProvinceCode, a.CountryRegionCode, a.City, a.AddressLine1, a.AddressLine2, a.PostalCode, a.StateProvinceName, a.CountryRegionName, st.SalesTerritoryKey
    FROM AdventureWorksOldData.Person.Customer a
    INNER JOIN Sales.SalesTerritory st ON a.SalesTerritoryKey = st.SalesTerritoryKey;
END;
GO

EXEC Sales.MigrateAddress;
GO

CREATE PROCEDURE Sales.MigrateCurrency 
  AS
  BEGIN
	INSERT INTO Sales.Currency (CurrencyAlternateKey, CurrencyName) 
	SELECT DISTINCT CurrencyAlternateKey, CurrencyName FROM AdventureWorksOldData.Sales.Currency; 
END;
GO

EXEC Sales.MigrateCurrency; 
GO



-- Migration Procedure for Customer
CREATE PROCEDURE Sales.MigrateCustomer
AS
BEGIN
    INSERT INTO Sales.Customer (LastName, FirstName, NameStyle, BirthDate, MaritalStatus, Gender, EmailAddress, YearlyIncome, Title, MiddleName, TotalChildren, NumberChildrenAtHome, EducationLevel, Occupation, HouseOwnerFlag, NumberCarsOwned, Phone, DateFirstPurchase, CommuteDistance)
    SELECT DISTINCT
        c.LastName, c.FirstName, c.NameStyle, c.BirthDate, c.MaritalStatus, c.Gender, c.EmailAddress, c.YearlyIncome,
        c.Title, c.MiddleName, c.TotalChildren, c.NumberChildrenAtHome, c.Education, c.Occupation, c.HouseOwnerFlag,
        c.NumberCarsOwned, c.Phone, c.DateFirstPurchase, c.CommuteDistance
    FROM
        AdventureWorksOldData.Person.Customer c;
END;
GO

EXEC Sales.MigrateCustomer;
GO

-- Migration Procedure for CustomerAddress
CREATE PROCEDURE Sales.MigrateCustomerAddress
AS
BEGIN
	INSERT INTO Sales.CustomerAddress(CustomerKey)
		SELECT sc.CustomerKey FROM Sales.Customer sc
		JOIN Sales.Customer c ON sc.CustomerKey = c.CustomerKey; 

	INSERT INTO Sales.CustomerAddress(AddressKey)
		SELECT a.AddressKey FROM Sales.Address a
		JOIN Sales.Address ad ON ad.AddressKey = a.AddressKey; 
END;
GO




EXEC Sales.MigrateCustomerAddress;
GO

SELECT * FROM Sales.CustomerAddress;

CREATE PROCEDURE Sales.MigrateSalesOrderHeader
AS
BEGIN
	INSERT INTO Sales.SalesOrderHeader(SalesOrderNumber, DueDate, OrderDate, CustomerPONumber, CarrierTrackingNumber, OrderDateKey, DueDateKey, RevisionNumber, ShipDateKey, ShipDate, CustomerKey, CurrencyKey, SalesTerritoryKey)
	SELECT DISTINCT s.SalesOrderNumber, s.DueDate, s.OrderDate, s.CustomerPONumber, s.CarrierTrackingNumber, s.OrderDateKey, s.DueDateKey, s.RevisionNumber, s.ShipDateKey, s.ShipDate, s.CustomerKey, s.CurrencyKey, s.SalesTerritoryKey 
	FROM AdventureWorksOldData.Sales.Sales7 s
	JOIN Sales.Customer c ON s.CustomerKey = c.CustomerKey 
	JOIN Sales.Currency cy ON s.CurrencyKey = cy.CurrencyKey
	JOIN Sales.SalesTerritory st ON s.SalesTerritoryKey = st.SalesTerritoryKey ;
END;
GO


EXEC Sales.MigrateSalesOrderHeader
GO 

CREATE PROCEDURE Sales.MigrateSalesOrderDetail
AS
BEGIN
    INSERT INTO Sales.SalesOrderDetail(TaxAmt,
        SalesAmount, SalesOrderLineNumber, DiscountAmount, UnitPriceDiscountPct, OrderQuantity, ProductStandardCost, UnitPrice, TotalProductCost, ExtendedAmount, ProductKey )
    SELECT s.TaxAmt, s.SalesAmount, s.SalesOrderLineNumber, s.DiscountAmount, s.UnitPriceDiscountPct, s.OrderQuantity, s.ProductStandardCost, s.UnitPrice, s.TotalProductCost, s.ExtendedAmount, p.ProductKey
    FROM
        AdventureWorksOldData.Sales.Sales7 s
		JOIN Production.Product p ON s.ProductKey = p.ProductKey;
END;
GO

EXEC Sales.MigrateSalesOrderDetail;
GO


-- Category Table
SELECT * FROM Production.Category;

-- SubCategory Table
SELECT * FROM Production.SubCategory;

-- Currency Table
SELECT * FROM Sales.Currency;

-- SalesTerritory Table
SELECT * FROM Sales.SalesTerritory;

-- Address Table
SELECT * FROM Sales.Address;

-- Customer Table
SELECT * FROM Sales.Customer;

SELECT * FROM Sales.CustomerAddress;

-- SalesOrderHeader Table
SELECT * FROM Sales.SalesOrderHeader;

-- Description Table
SELECT * FROM Production.Description;

-- Product Table
SELECT * FROM Production.Product;

-- SalesOrderDetail Table
SELECT * FROM Sales.SalesOrderDetail;

-- Count records in Category Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Production.Category;

-- Count records in SubCategory Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Production.SubCategory;

-- Count records in Currency Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Sales.Currency;

-- Count records in SalesTerritory Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Sales.SalesTerritory;

-- Count records in Address Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Sales.Address;

-- Count records in Customer Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Sales.Customer;

-- Count records in SalesOrderHeader Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Sales.SalesOrderHeader;

-- Count records in Description Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Production.Description;

-- Count records in Product Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Production.Product;

-- Count records in SalesOrderDetail Table
SELECT COUNT(*) AS NumeroDeRegistos FROM Sales.SalesOrderDetail;
