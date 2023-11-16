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

    -- Multiply the number if necessary
    SET @password = @password * 2;

    RETURN @password;
END;
GO

-- Test the function
SELECT dbo.GenerateRandomPassword() AS SenhaAleatoria;