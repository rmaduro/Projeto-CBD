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
GO

-- Category Table
CREATE TABLE Production.Category (
  CategoryKey INT IDENTITY(1,1) PRIMARY KEY,
  FrenchCategoryName VARCHAR(50),
  -- SubCategoryKey TINYINT,
  EnglishCategoryName VARCHAR(50),
  SpanishCategoryName VARCHAR(50)
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

-- Sales Table
CREATE TABLE Sales.Sales (
  SalesKey INT IDENTITY(1,1) PRIMARY KEY,
  SalesOrderNumber VARCHAR(50),
  DueDate DATE,
  OrderDate DATE,
  CustomerPONumber SMALLINT,
  CarrierTrackingNumber TINYINT,
  TaxAmt SMALLINT,
  SalesAmount FLOAT,
  DueDateKey DATE,
  PromotionKey TINYINT,
  SalesOrderLineNumber TINYINT,
  DiscountAmount TINYINT,
  UnitPriceDiscountPct TINYINT,
  OrderQuantity TINYINT,
  ProductStandardCost FLOAT,
  UnitPrice FLOAT,
  TotalProductCost FLOAT,
  OrderDateKey DATE,
  ExtendedAmount FLOAT,
  RevisionNumber TINYINT,
  ShipDateKey DATE,
  ShipDate DATETIME2(7),
  CurrencyKey TINYINT,
  FOREIGN KEY (CurrencyKey) REFERENCES Sales.Currency(CurrencyKey)
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

-- SalesTerritory_Sales Table
CREATE TABLE Sales.SalesTerritory_Sales (
  SalesTerritoryKey INT,
  SalesKey INT,
  FOREIGN KEY (SalesTerritoryKey) REFERENCES Sales.SalesTerritory(SalesTerritoryKey),
  FOREIGN KEY (SalesKey) REFERENCES Sales.Sales(SalesKey),
  PRIMARY KEY (SalesTerritoryKey, SalesKey)
);

-- Sales_Currency Table
CREATE TABLE Sales.Sales_Currency (
  SalesKey INT,
  CurrencyKey TINYINT,
  FOREIGN KEY (SalesKey) REFERENCES Sales.Sales(SalesKey),
  FOREIGN KEY (CurrencyKey) REFERENCES Sales.Currency(CurrencyKey),
  PRIMARY KEY (SalesKey, CurrencyKey)
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
  CategoryKey INT,
  SalesKey INT,
  FOREIGN KEY (CategoryKey) REFERENCES Production.Category(CategoryKey),
  FOREIGN KEY (SalesKey) REFERENCES Sales.Sales(SalesKey)
);

-- Description Table
CREATE TABLE Production.Description (
  DescriptionKey INT IDENTITY(1,1) PRIMARY KEY,
  FrenchDescription NVARCHAR(1000), 
  EnglishDescription NVARCHAR(255),
  SpanishProductName NVARCHAR(255),
  EnglishProductName NVARCHAR(255),
  FrenchProductName NVARCHAR(255),
  productKey INT,
  FOREIGN KEY (productKey) REFERENCES Production.Product(productKey)
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
DROP PROCEDURE IF EXISTS Production.MigrateDescription
GO
DROP PROCEDURE IF EXISTS Production.MigrateProduct
GO


CREATE PROCEDURE Sales.MigrateAddress
AS
BEGIN

    INSERT INTO Sales.Address (StateProvince, CountryRegion, City, AddressLine1, AddressLine2, PostalCode, StateProvinceName, CountryRegionName)
    SELECT  StateProvinceCode, CountryRegionCode, City, AddressLine1, AddressLine2, PostalCode, StateProvinceName, CountryRegionName
    FROM AdventureWorksOld7.ADOld.Customer;
END;
GO

EXEC Sales.MigrateAddress;
GO


CREATE PROCEDURE Production.MigrateProduct 
AS
BEGIN 
	INSERT INTO Production.Product (Size, SizeUnitMeasureCode, DaysToManufacture, Color, SizeRange, StandardCost, ListPrice, SafetyStockLevel, WeightUnitMeasureCode, FinishedGoodsFlag, Weight, Class, ProductLine, DealerPrice, ModelName, Status) 
	SELECT Size, SizeUnitMeasureCode, DaysToManufacture, Color, SizeRange, StandardCost, ListPrice, SafetyStockLevel, WeightUnitMeasureCode, FinishedGoodsFlag, Weight, Class, ProductLine, DealerPrice, ModelName, Status 
	FROM AdventureWorksOld7.ADOld.Products; 
END;
GO

EXEC Production.MigrateProduct
GO


  CREATE PROCEDURE Sales.MigrateCurrency 
  AS
  BEGIN
	INSERT INTO Sales.Currency (CurrencyAlternateKey, CurrencyName) 
	SELECT CurrencyAlternateKey, CurrencyName FROM AdventureWorksOld7.ADOld.Currency; 
END;
GO

EXEC Sales.MigrateCurrency; 
GO


CREATE PROCEDURE Sales.MigrateSales 
AS 
BEGIN 
	INSERT INTO Sales.Sales (SalesOrderNumber, DueDate, OrderDate, CustomerPONumber, CarrierTrackingNumber, TaxAmt, SalesAmount, DueDateKey, PromotionKey, SalesOrderLineNumber, DiscountAmount, UnitPriceDiscountPct, OrderQuantity, ProductStandardCost, UnitPrice, TotalProductCost, OrderDateKey, ExtendedAmount, RevisionNumber, ShipDateKey, ShipDate) 
	SELECT SalesOrderNumber, DueDate, OrderDate, CustomerPONumber, CarrierTrackingNumber, TaxAmt, SalesAmount, DueDateKey, PromotionKey, SalesOrderLineNumber, DiscountAmount, UnitPriceDiscountPct, OrderQuantity, ProductStandardCost, UnitPrice, TotalProductCost, OrderDateKey, ExtendedAmount, RevisionNumber, ShipDateKey, ShipDate
	FROM AdventureWorksOld7.ADOld.sales7Temp; 
END;
GO

EXEC Sales.MigrateSales; 
GO


CREATE PROCEDURE Sales.MigrateSalesTerritory
AS
BEGIN
    INSERT INTO Sales.SalesTerritory (SalesTerritoryCountry, SalesTerritoryRegion, SalesTerritoryGroup)
    SELECT SalesTerritoryCountry, SalesTerritoryRegion, SalesTerritoryGroup
    FROM AdventureWorksOld7.ADOld.SalesTerritory;
END;
GO

EXEC Sales.MigrateSalesTerritory;
GO


CREATE PROCEDURE Sales.MigrateCustomer
AS
BEGIN
    INSERT INTO Sales.Customer(LastName, NameStyle, BirthDate, MaritalStatus, Gender, EmailAddress, YearlyIncome, Title, MiddleName, TotalChildren, NumberChildrenAtHome, EducationLevel, Occupation, HouseOwnerFlag, NumberCarsOwned, Phone, DateFirstPurchase, CommuteDistance)
    SELECT LastName, NameStyle, BirthDate, MaritalStatus, Gender, EmailAddress, YearlyIncome, Title, MiddleName, TotalChildren, NumberChildrenAtHome, Education, Occupation, HouseOwnerFlag, NumberCarsOwned, Phone, DateFirstPurchase, CommuteDistance
    FROM AdventureWorksOld7.ADOld.Customer;
END;
GO

EXEC Sales.MigrateCustomer;
GO



CREATE PROCEDURE Production.MigrateCategory
AS
BEGIN
    INSERT INTO Production.Category (FrenchCategoryName, EnglishCategoryName, SpanishCategoryName)
    SELECT FrenchProductCategoryName, EnglishProductCategoryName, SpanishProductCategoryName
    FROM AdventureWorksOld7.ADOld.Products;

	-- INSERT INTO Production.Category (SubCategoryKey)
	-- SELECT ProductSubcategoryKey
	-- FROM AdventureWorksOld7.ADOld.ProductSubCategory
END;
GO

EXEC Production.MigrateCategory;
GO


CREATE PROCEDURE Production.MigrateDescription
AS
BEGIN
    INSERT INTO Production.Description (FrenchDescription, EnglishDescription, SpanishProductName, EnglishProductName, FrenchProductName)
    SELECT FrenchDescription, EnglishDescription, SpanishProductName, EnglishProductName, FrenchProductName
    FROM AdventureWorksOld7.ADOld.Products;
END;
GO

EXEC Production.MigrateDescription;