




CREATE PROCEDURE Sales.MigrateSales 
AS 
BEGIN 
    INSERT INTO Sales.Sales (SalesOrderNumber, DueDate, OrderDate, CustomerPONumber, CarrierTrackingNumber, TaxAmt, SalesAmount, DueDateKey, PromotionKey, SalesOrderLineNumber, DiscountAmount, UnitPriceDiscountPct, OrderQuantity, ProductStandardCost, UnitPrice, TotalProductCost, OrderDateKey, ExtendedAmount, RevisionNumber, ShipDateKey, ShipDate, CurrencyKey) 
    SELECT DISTINCT s.SalesOrderNumber, s.DueDate, s.OrderDate, s.CustomerPONumber, s.CarrierTrackingNumber, s.TaxAmt, s.SalesAmount, s.DueDateKey, s.PromotionKey, s.SalesOrderLineNumber, s.DiscountAmount, s.UnitPriceDiscountPct, s.OrderQuantity, s.ProductStandardCost, s.UnitPrice, s.TotalProductCost, s.OrderDateKey, s.ExtendedAmount, s.RevisionNumber, s.ShipDateKey, s.ShipDate, c.CurrencyKey
    FROM AdventureWorksOldData.Sales.Sales7 s
    INNER JOIN Sales.Currency c ON s.CurrencyKey = c.CurrencyKey;
END;
GO

EXEC Sales.MigrateSales;
GO


5

SELECT * FROM Production.Product;
SELECT * FROM Production.Category;


CREATE PROCEDURE Sales.MigrateCustomer
AS
BEGIN
    INSERT INTO Sales.Customer(LastName, NameStyle, BirthDate, MaritalStatus, Gender, EmailAddress, YearlyIncome, Title, MiddleName, TotalChildren, NumberChildrenAtHome, EducationLevel, Occupation, HouseOwnerFlag, NumberCarsOwned, Phone, DateFirstPurchase, CommuteDistance, AddressKey)
    SELECT c.LastName, c.NameStyle, c.BirthDate, c.MaritalStatus, c.Gender, c.EmailAddress, c.YearlyIncome, c.Title, c.MiddleName, c.TotalChildren, c.NumberChildrenAtHome, c.Education, c.Occupation, c.HouseOwnerFlag, c.NumberCarsOwned, c.Phone, c.DateFirstPurchase, c.CommuteDistance, a.AddressKey
    FROM AdventureWorksOldData.Person.Customer c
    INNER JOIN Sales.Address a ON c.AddressLine1 = a.AddressLine1;
END;
GO


EXEC Sales.MigrateCustomer;
GO
