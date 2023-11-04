-- Drop the AdventureWorks database if it exists
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'AdventureWorks')
    DROP DATABASE AdventureWorks;
GO

-- Create the AdventureWorks database if it does not exist
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'AdventureWorks')
    CREATE DATABASE AdventureWorks;
GO


-- Drop the tables if they exist
IF OBJECT_ID('SalesTerritory_Sales', 'U') IS NOT NULL
    DROP TABLE SalesTerritory_Sales;
IF OBJECT_ID('Sales_Currency', 'U') IS NOT NULL
    DROP TABLE Sales_Currency;
IF OBJECT_ID('Description', 'U') IS NOT NULL
    DROP TABLE Description;
IF OBJECT_ID('Product', 'U') IS NOT NULL
    DROP TABLE Product;
IF OBJECT_ID('Address', 'U') IS NOT NULL
    DROP TABLE Address;
IF OBJECT_ID('Client', 'U') IS NOT NULL
    DROP TABLE Client;
IF OBJECT_ID('Sales', 'U') IS NOT NULL
    DROP TABLE Sales;
IF OBJECT_ID('Category', 'U') IS NOT NULL
    DROP TABLE Category;
IF OBJECT_ID('Currency', 'U') IS NOT NULL
    DROP TABLE Currency;
IF OBJECT_ID('SalesTerritory', 'U') IS NOT NULL
    DROP TABLE SalesTerritory;
GO				

-- Category Table
CREATE TABLE Category (
  CategoryKey INT NOT NULL,
  FrenchCategoryName VARCHAR(50),
  ParentCategoryKey VARCHAR(50),
  EnglishCategoryName VARCHAR(50),
  SpanishCategoryName VARCHAR(50),
  PRIMARY KEY (CategoryKey)
);

-- Currency Table
CREATE TABLE Currency (
  CurrencyKey INT NOT NULL,
  CurrencyAlternateKey INT NOT NULL,
  CurrencyName VARCHAR(50) NOT NULL,
  PRIMARY KEY (CurrencyKey)
);

-- SalesTerritory Table
CREATE TABLE SalesTerritory (
  SalesTerritoryKey INT NOT NULL,
  SalesTerritoryCountry VARCHAR(255) NOT NULL,
  SalesTerritoryRegion VARCHAR(255) NOT NULL,
  SalesTerritoryGroup VARCHAR(255) NOT NULL,
  PRIMARY KEY (SalesTerritoryKey)
);

-- Sales Table
CREATE TABLE Sales (
  SalesOrderNumber INT NOT NULL,
  DueDate DATE NOT NULL,
  OrderDate DATE NOT NULL,
  CustomerPONumber INT NOT NULL,
  CarrierTrackingNumber INT NOT NULL,
  TaxAmt INT NOT NULL,
  SalesAmount INT NOT NULL,
  DueDateKey INT NOT NULL,
  PromotionKey INT NOT NULL,
  SalesOrderLineNumber INT NOT NULL,
  DiscountAmount INT NOT NULL,
  UnitPriceDiscountPct INT NOT NULL,
  OrderQuantity INT NOT NULL,
  ProductStandardCost INT NOT NULL,
  UnitPrice INT NOT NULL,
  TotalProductCost INT NOT NULL,
  OrderDateKey INT NOT NULL,
  ExtendedAmount INT NOT NULL,
  RevisionNumber INT NOT NULL,
  ShipDateKey INT NOT NULL,
  ShipDate INT NOT NULL,
  CurrencyKey INT NOT NULL,
  PRIMARY KEY (SalesOrderNumber),
  FOREIGN KEY (CurrencyKey) REFERENCES Currency(CurrencyKey)
);

-- Client Table
CREATE TABLE Client (
  CustomerKey INT NOT NULL,
  LastName VARCHAR(255) NOT NULL,
  NameStyle BIT NOT NULL,
  BirthDate DATE NOT NULL,
  MaritalStatus BIT NOT NULL,
  Gender VARCHAR(50) NOT NULL,
  EmailAddress VARCHAR(255) NOT NULL,
  YearlyIncome INT NOT NULL,
  Title VARCHAR(50) NOT NULL,
  FirstNameAttribute VARCHAR(50) NOT NULL,
  MiddleName VARCHAR(255) NOT NULL,
  TotalChildren INT NOT NULL,
  NumberChildrenAtHome INT NOT NULL,
  EducationLevel INT NOT NULL CHECK (EducationLevel IN (1, 2, 3, 4, 5)), -- 1: High School, 2: College, 3: Graduate, 4: Post-graduate, 5: Other
  Occupation VARCHAR(50) NOT NULL,
  HouseOwnerFlag BIT NOT NULL,
  NumberCarsOwned INT NOT NULL,
  Phone VARCHAR(255) NOT NULL,
  DateFirstPurchase DATE NOT NULL,
  CommuteDistance INT NOT NULL,
  PRIMARY KEY (CustomerKey)
);

-- SalesTerritory_Sales Table
CREATE TABLE SalesTerritory_Sales (
  SalesTerritoryKey INT NOT NULL,
  SalesOrderNumber INT NOT NULL,
  FOREIGN KEY (SalesTerritoryKey) REFERENCES SalesTerritory(SalesTerritoryKey),
  FOREIGN KEY (SalesOrderNumber) REFERENCES Sales(SalesOrderNumber),
  PRIMARY KEY (SalesTerritoryKey, SalesOrderNumber)
);

-- Sales_Currency Table
CREATE TABLE Sales_Currency (
  SalesOrderNumber INT NOT NULL,
  CurrencyKey INT NOT NULL,
  FOREIGN KEY (SalesOrderNumber) REFERENCES Sales(SalesOrderNumber),
  FOREIGN KEY (CurrencyKey) REFERENCES Currency(CurrencyKey),
  PRIMARY KEY (SalesOrderNumber, CurrencyKey)
);

-- Product Table
CREATE TABLE Product (
  productKey INT NOT NULL,
  Size INT NOT NULL,
  SizeUnitMeasureCode INT NOT NULL,
  DaysToManufacture INT NOT NULL,
  Color VARCHAR(50) NOT NULL,
  SizeRange INT NOT NULL,
  StandardCost INT NOT NULL,
  ListPrice INT NOT NULL,
  SafetyStockLevel INT NOT NULL,
  WeightUnitMeasureCode INT NOT NULL,
  FinishedGoodsFlag BIT NOT NULL,
  Weight INT NOT NULL,
  Class VARCHAR(50) NOT NULL,
  ProductLine VARCHAR(50) NOT NULL,
  DealerPrice INT NOT NULL,
  ModelName VARCHAR(50) NOT NULL,
  Status VARCHAR(20) NOT NULL CHECK (Status IN ('Available', 'Out of Stock', 'Discontinued', 'In Production')), -- Enum for status
  CategoryKey INT NOT NULL,
  SalesOrderNumber INT NOT NULL,
  FOREIGN KEY (CategoryKey) REFERENCES Category(CategoryKey),
  FOREIGN KEY (SalesOrderNumber) REFERENCES Sales(SalesOrderNumber),
  PRIMARY KEY (productKey)
);

-- Address Table
CREATE TABLE Address (
  AddressKey INT NOT NULL,
  StateProvince INT NOT NULL,
  CountryRegion INT NOT NULL,
  City VARCHAR(50) NOT NULL,
  AddressLine2 VARCHAR(255) NOT NULL,
  AddressLine1 VARCHAR(255) NOT NULL,
  PostalCode Varchar(50) NOT NULL,
  StateProvinceName VARCHAR(255) NOT NULL,
  CountryRegionName VARCHAR(255) NOT NULL,
  SalesTerritoryKey INT NOT NULL,
  CustomerKey INT NOT NULL,
  FOREIGN KEY (SalesTerritoryKey) REFERENCES SalesTerritory(SalesTerritoryKey),
  FOREIGN KEY (CustomerKey) REFERENCES Client(CustomerKey),
  PRIMARY KEY (AddressKey)
);

-- Description Table
CREATE TABLE Description (
  DescriptionKey INT NOT NULL,
  FrenchDescription VARCHAR(255) NOT NULL,
  EnglishDescription VARCHAR(255) NOT NULL,
  SpanishProductName VARCHAR(255) NOT NULL,
  EnglishProductName VARCHAR(255) NOT NULL,
  FrenchProductName VARCHAR(255) NOT NULL,
  SpanishDescription VARCHAR(255) NOT NULL,
  productKey INT NOT NULL,
  FOREIGN KEY (productKey) REFERENCES Product(productKey),
  PRIMARY KEY (DescriptionKey)
);

