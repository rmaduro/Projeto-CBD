USE AdventureWorks;
GO


-- Drop the existing view and function
DROP VIEW IF EXISTS getNumber;
DROP FUNCTION IF EXISTS dbo.GenerateRandomPassword;
GO

-- Create a view to generate a random number between 0 and 1
CREATE VIEW getNumber AS 
SELECT CAST(RAND() * 1000000 AS INT) AS new_number;
GO

-- Create the function to generate a password
CREATE FUNCTION dbo.GenerateRandomPassword()
RETURNS INT
AS
BEGIN
    DECLARE @password INT;

    -- Retrieve the random number from the view
    SET @password = (
        SELECT new_number
        FROM getNumber
    );

    SET @password = @password * 2;

    RETURN @password;
END;
GO

-- Test the function
SELECT dbo.GenerateRandomPassword() AS SenhaAleatoria;


GO




-- Procedure to add a new category
CREATE PROCEDURE Production.AddCategory
  @FrenchCategoryName VARCHAR(50),
  @EnglishCategoryName VARCHAR(50),
  @SpanishCategoryName VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Production.Category (FrenchCategoryName, EnglishCategoryName, SpanishCategoryName)
        VALUES (@FrenchCategoryName, @EnglishCategoryName, @SpanishCategoryName);
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while adding a new category.';
    END CATCH
END;
GO

-- Procedure to remove a category
CREATE PROCEDURE Production.RemoveCategory
  @CategoryKey INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Production.Category
        WHERE CategoryKey = @CategoryKey;
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while removing a category.';
    END CATCH
END;
GO

-- Procedure to add a new subcategory
CREATE PROCEDURE Production.AddSubCategory
  @FrenchSubCategoryName VARCHAR(50),
  @EnglishSubCategoryName VARCHAR(50),
  @SpanishSubCategoryName VARCHAR(50),
  @CategoryKey INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Production.SubCategory (FrenchSubCategoryName, EnglishSubCategoryName, SpanishSubCategoryName, CategoryKey)
        VALUES (@FrenchSubCategoryName, @EnglishSubCategoryName, @SpanishSubCategoryName, @CategoryKey);
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while adding a new subcategory.';
    END CATCH
END;
GO

-- Procedure to remove a subcategory
CREATE PROCEDURE Production.RemoveSubCategory
  @SubCategoryKey INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Production.SubCategory
        WHERE SubCategoryKey = @SubCategoryKey;
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while removing a subcategory.';
    END CATCH
END;
GO

-- Procedure to add a new currency
CREATE PROCEDURE Sales.AddCurrency
  @CurrencyAlternateKey VARCHAR(50),
  @CurrencyName VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Sales.Currency (CurrencyAlternateKey, CurrencyName)
        VALUES (@CurrencyAlternateKey, @CurrencyName);
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while adding a new currency.';
    END CATCH
END;
GO

-- Procedure to remove a currency
CREATE PROCEDURE Sales.RemoveCurrency
  @CurrencyKey TINYINT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Sales.Currency
        WHERE CurrencyKey = @CurrencyKey;
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while removing a currency.';
    END CATCH
END;
GO

-- Procedure to add a new sales territory
CREATE PROCEDURE Sales.AddSalesTerritory
  @SalesTerritoryCountry VARCHAR(255),
  @SalesTerritoryRegion VARCHAR(255),
  @SalesTerritoryGroup VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Sales.SalesTerritory (SalesTerritoryCountry, SalesTerritoryRegion, SalesTerritoryGroup)
        VALUES (@SalesTerritoryCountry, @SalesTerritoryRegion, @SalesTerritoryGroup);
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while adding a new sales territory.';
    END CATCH
END;
GO

-- Procedure to remove a sales territory
CREATE PROCEDURE Sales.RemoveSalesTerritory
  @SalesTerritoryKey INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Sales.SalesTerritory
        WHERE SalesTerritoryKey = @SalesTerritoryKey;
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while removing a sales territory.';
    END CATCH
END;
GO

-- Procedure to add a new customer
CREATE PROCEDURE Person.AddCustomer
  @LastName VARCHAR(255),
  @FirstName VARCHAR(50),
  @MiddleName VARCHAR(50),
  @NameStyle VARCHAR(50),
  @BirthDate DATE,
  @MaritalStatus VARCHAR(50),
  @Gender VARCHAR(50),
  @EmailAddress VARCHAR(50),
  @YearlyIncome INT,
  @Title VARCHAR(10),
  @TotalChildren TINYINT,
  @NumberChildrenAtHome TINYINT,
  @EducationLevel VARCHAR(50),
  @Occupation VARCHAR(50),
  @HouseOwnerFlag BIT,
  @NumberCarsOwned TINYINT,
  @Phone VARCHAR(50),
  @DateFirstPurchase DATE,
  @CommuteDistance VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Person.Customer (LastName, FirstName, MiddleName, NameStyle, BirthDate, MaritalStatus, Gender, EmailAddress, YearlyIncome, Title, TotalChildren, NumberChildrenAtHome, EducationLevel, Occupation, HouseOwnerFlag, NumberCarsOwned, Phone, DateFirstPurchase, CommuteDistance)
        VALUES (@LastName, @FirstName, @MiddleName, @NameStyle, @BirthDate, @MaritalStatus, @Gender, @EmailAddress, @YearlyIncome, @Title, @TotalChildren, @NumberChildrenAtHome, @EducationLevel, @Occupation, @HouseOwnerFlag, @NumberCarsOwned, @Phone, @DateFirstPurchase, @CommuteDistance);
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while adding a new customer.';
    END CATCH
END;
GO

-- Procedure to remove a customer
CREATE PROCEDURE Person.RemoveCustomer
  @CustomerKey INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Person.Customer
        WHERE CustomerKey = @CustomerKey;
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while removing a customer.';
    END CATCH
END;
GO

-- Procedure to add a new address
CREATE PROCEDURE Sales.AddAddress
  @StateProvince VARCHAR(50),
  @CountryRegion VARCHAR(50),
  @City VARCHAR(50),
  @AddressLine2 VARCHAR(255),
  @AddressLine1 VARCHAR(255),
  @PostalCode VARCHAR(50),
  @StateProvinceName VARCHAR(255),
  @CountryRegionName VARCHAR(255),
  @SalesTerritoryKey INT,
  @CustomerKey INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Sales.Address (StateProvince, CountryRegion, City, AddressLine2, AddressLine1, PostalCode, StateProvinceName, CountryRegionName, SalesTerritoryKey, CustomerKey)
        VALUES (@StateProvince, @CountryRegion, @City, @AddressLine2, @AddressLine1, @PostalCode, @StateProvinceName, @CountryRegionName, @SalesTerritoryKey, @CustomerKey);
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while adding a new address.';
    END CATCH
END;
GO

-- Procedure to remove an address
CREATE PROCEDURE Sales.RemoveAddress
  @AddressKey INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Sales.Address
        WHERE AddressKey = @AddressKey;
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while removing an address.';
    END CATCH
END;
GO

-- Procedure to add a new description
CREATE PROCEDURE Production.AddDescription
  @FrenchDescription NVARCHAR(1000),
  @EnglishDescription NVARCHAR(255),
  @SpanishProductName NVARCHAR(255),
  @EnglishProductName NVARCHAR(255),
  @FrenchProductName NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Production.Description (FrenchDescription, EnglishDescription, SpanishProductName, EnglishProductName, FrenchProductName)
        VALUES (@FrenchDescription, @EnglishDescription, @SpanishProductName, @EnglishProductName, @FrenchProductName);
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while adding a new description.';
    END CATCH
END;
GO

-- Procedure to remove a description
CREATE PROCEDURE Production.RemoveDescription
  @DescriptionKey INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Production.Description
        WHERE DescriptionKey = @DescriptionKey;
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while removing a description.';
    END CATCH
END;
GO

-- Procedure to add a new product
CREATE PROCEDURE Production.AddProduct
  @Size VARCHAR(50),
  @SizeUnitMeasureCode VARCHAR(50),
  @DaysToManufacture TINYINT,
  @Color VARCHAR(50),
  @SizeRange VARCHAR(50),
  @StandardCost FLOAT,
  @ListPrice FLOAT,
  @SafetyStockLevel SMALLINT,
  @WeightUnitMeasureCode VARCHAR(50),
  @FinishedGoodsFlag VARCHAR(50),
  @Weight FLOAT,
  @Class VARCHAR(50),
  @ProductLine VARCHAR(50),
  @DealerPrice FLOAT,
  @ModelName VARCHAR(50),
  @Status VARCHAR(50),
  @SubCategoryKey INT,
  @DescriptionKey INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Production.Product (Size, SizeUnitMeasureCode, DaysToManufacture, Color, SizeRange, StandardCost, ListPrice, SafetyStockLevel, WeightUnitMeasureCode, FinishedGoodsFlag, Weight, Class, ProductLine, DealerPrice, ModelName, Status, SubCategoryKey, DescriptionKey)
        VALUES (@Size, @SizeUnitMeasureCode, @DaysToManufacture, @Color, @SizeRange, @StandardCost, @ListPrice, @SafetyStockLevel, @WeightUnitMeasureCode, @FinishedGoodsFlag, @Weight, @Class, @ProductLine, @DealerPrice, @ModelName, @Status, @SubCategoryKey, @DescriptionKey);
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while adding a new product.';
    END CATCH
END;
GO

-- Procedure to remove a product
CREATE PROCEDURE Production.RemoveProduct
  @ProductKey INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Production.Product
        WHERE ProductKey = @ProductKey;
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while removing a product.';
    END CATCH
END;
GO

-- Procedure to add a new sales order header
CREATE PROCEDURE Sales.AddSalesOrderHeader
  @SalesOrderNumber VARCHAR(50),
  @DueDate DATE,
  @OrderDate DATE,
  @CustomerPONumber SMALLINT,
  @CarrierTrackingNumber TINYINT,
  @OrderDateKey DATE,
  @DueDateKey DATE,
  @RevisionNumber TINYINT,
  @ShipDateKey DATE,
  @ShipDate DATETIME2(7),
  @CustomerKey INT,
  @CurrencyKey TINYINT,
  @SalesTerritoryKey INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Sales.SalesOrderHeader(SalesOrderNumber, DueDate, OrderDate, CustomerPONumber, CarrierTrackingNumber, OrderDateKey, DueDateKey, RevisionNumber, ShipDateKey, ShipDate, CustomerKey, CurrencyKey, SalesTerritoryKey)
        VALUES (@SalesOrderNumber, @DueDate, @OrderDate, @CustomerPONumber, @CarrierTrackingNumber, @OrderDateKey, @DueDateKey, @RevisionNumber, @ShipDateKey, @ShipDate, @CustomerKey, @CurrencyKey, @SalesTerritoryKey);
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while adding a new sales order header.';
    END CATCH
END;
GO

-- Procedure to remove a sales order header
CREATE PROCEDURE Sales.RemoveSalesOrderHeader
  @SalesOrderNumber VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        DELETE FROM Sales.SalesOrderHeader
        WHERE SalesOrderNumber = @SalesOrderNumber;
    END TRY
    BEGIN CATCH
        -- Handle the error (you can log it, raise a custom error, or take appropriate action)
        PRINT 'Error occurred while removing a sales order header.';
    END CATCH
END;
GO


-- Procedure to add a new sales order detail
CREATE PROCEDURE Sales.AddSalesOrderDetail
  @SalesOrderNumber VARCHAR(50),
  @TaxAmt INT,
  @SalesAmount FLOAT,
  @SalesOrderLineNumber TINYINT,
  @DiscountAmount TINYINT,
  @UnitPriceDiscountPct TINYINT,
  @OrderQuantity TINYINT,
  @ProductStandardCost FLOAT,
  @UnitPrice FLOAT,
  @TotalProductCost FLOAT,
  @ExtendedAmount FLOAT,
  @ProductKey INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Sales.SalesOrderDetail (SalesOrderNumber, TaxAmt, SalesAmount, SalesOrderLineNumber, DiscountAmount, UnitPriceDiscountPct, OrderQuantity, ProductStandardCost, UnitPrice, TotalProductCost, ExtendedAmount, ProductKey)
        VALUES (@SalesOrderNumber, @TaxAmt, @SalesAmount, @SalesOrderLineNumber, @DiscountAmount, @UnitPriceDiscountPct, @OrderQuantity, @ProductStandardCost, @UnitPrice, @TotalProductCost, @ExtendedAmount, @ProductKey);
    END TRY
    BEGIN CATCH
        -- Add error handling logic here
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO

-- Procedure to remove a sales order detail
CREATE PROCEDURE Sales.RemoveSalesOrderDetail
  @SalesOrderKey INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Sales.SalesOrderDetail
        WHERE SalesOrderKey = @SalesOrderKey;
    END TRY
    BEGIN CATCH
        -- Add error handling logic here
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
