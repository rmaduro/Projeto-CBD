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
IF OBJECT_ID('Sales.Sales_Currency', 'U') IS NOT NULL
    DROP TABLE Sales.Sales_Currency;
IF OBJECT_ID('Sales.SalesTerritory_Sales', 'U') IS NOT NULL
    DROP TABLE Sales.SalesTerritory_Sales;
IF OBJECT_ID('Sales.Customer', 'U') IS NOT NULL
    DROP TABLE Sales.Customer;
IF OBJECT_ID('Sales.Address', 'U') IS NOT NULL
    DROP TABLE Sales.Address;
IF OBJECT_ID('Production.Product', 'U') IS NOT NULL
    DROP TABLE Production.Product;
IF OBJECT_ID('Sales.Sales', 'U') IS NOT NULL
    DROP TABLE Sales.Sales;
IF OBJECT_ID('Sales.Currency', 'U') IS NOT NULL
    DROP TABLE Sales.Currency;
IF OBJECT_ID('Sales.SalesTerritory', 'U') IS NOT NULL
    DROP TABLE Sales.SalesTerritory;
IF OBJECT_ID('Production.Description', 'U') IS NOT NULL
    DROP TABLE Production.Description;
IF OBJECT_ID('Production.Category', 'U') IS NOT NULL
    DROP TABLE Production.Category;
IF OBJECT_ID('Production.SubCategory', 'U') IS NOT NULL
    DROP TABLE Production.SubCategory;
GO

-- Category Table
CREATE TABLE Production.Category (
  CategoryKey INT IDENTITY(1,1) PRIMARY KEY,
  FrenchCategoryName VARCHAR(50),
  EnglishCategoryName VARCHAR(50),
  SpanishCategoryName VARCHAR(50),
);

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
  FOREIGN KEY (SalesTerritoryKey) REFERENCES Sales.SalesTerritory(SalesTerritoryKey)
);

-- Client Table
CREATE TABLE Sales.Customer (
  CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
  LastName VARCHAR(255),
  NameStyle VARCHAR(50),
  BirthDate DATE,
  MaritalStatus VARCHAR(50),
  Gender VARCHAR(50),
  EmailAddress VARCHAR(50),
  YearlyIncome INT,
  Title VARCHAR(10),
  MiddleName VARCHAR(50),
  TotalChildren TINYINT,
  NumberChildrenAtHome TINYINT,
  EducationLevel VARCHAR(50),
  Occupation VARCHAR(50),
  HouseOwnerFlag BIT,
  NumberCarsOwned TINYINT,
  Phone VARCHAR(50),
  DateFirstPurchase DATE,
  CommuteDistance VARCHAR(50),
  AddressKey INT,
  FOREIGN KEY (AddressKey) REFERENCES Sales.Address(AddressKey)
);

-- SalesOrderID Table
CREATE TABLE Sales.SalesOrderID (
SalesOrderNumber VARCHAR(50) PRIMARY KEY,
DueDate DATE,                                                           
OrderDate DATE,
CustomerPONumber SMALLINT,
CarrierTrackingNumber TINYINT,
OrderDateKey DATE,
DueDateKey DATE,
RevisionNumber TINYINT,
ShipDateKey DATE,
CustomerKey INT,
CurrencyKey TINYINT,
ShipDate DATETIME2(7),
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
  FrenchProductName NVARCHAR(255),
);

-- Product Table
CREATE TABLE Production.Product (
  productKey INT IDENTITY(1,1) PRIMARY KEY,
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
  FOREIGN KEY (SubCategoryKey) REFERENCES Production.SubCategory(SubCategoryKey),
);

-- SalesOrderID Table
CREATE TABLE Sales.SalesOrderDetailID (
SalesOrderKey INT IDENTITY(1,1) PRIMARY KEY,                                                        
TaxAmt SMALLINT,
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
  FOREIGN KEY (ProductKey) REFERENCES Production.Product(productKey)                                                 
);
-- Data Migration

DROP PROCEDURE IF EXISTS Sales.MigrateAddress
GO
DROP PROCEDURE IF EXISTS Sales.MigrateCustomer
GO
DROP PROCEDURE IF EXISTS Sales.MigrateCurrency
GO
DROP PROCEDURE IF EXISTS Sales.MigrateSales
GO
DROP PROCEDURE IF EXISTS Sales.MigrateSales_Currency
GO
DROP PROCEDURE IF EXISTS Sales.MigrateSalesTerritory
GO
DROP PROCEDURE IF EXISTS Sales.MigrateSalesTerritory_Sales
GO
DROP PROCEDURE IF EXISTS Production.MigrateCategory
GO
DROP PROCEDURE IF EXISTS Production.MigrateSubCategory
GO
DROP PROCEDURE IF EXISTS Production.MigrateDescription
GO
DROP PROCEDURE IF EXISTS Production.MigrateProduct
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
	JOIN Production.Category c ON p.EnglishProductCategoryName COLLATE SQL_Latin1_General_CP1_CI_AS= c.EnglishCategoryName COLLATE SQL_Latin1_General_CP1_CI_AS; 
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