




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



