/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03 (15:00h - 17:00h)
 *		Nome Aluno: Ricardo Pinto (nº 202200637)
 *		Nome Aluno: Rodrigo Maduro (nº 202200166)
 *	    Nome Aluno: Rodrigo Arraiado (nº 202100436)
 *	
 *			Database
 ********************************************/
 -- Section: Database Initialization
USE AdventureWorks;

-- Drop the existing view, function, and trigger
DROP VIEW IF EXISTS getNumber;
DROP FUNCTION IF EXISTS dbo.GenerateRandomPassword;
DROP TRIGGER IF EXISTS GenerateLoggin;
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
CREATE TRIGGER GenerateLoggin
ON Person.Customer
AFTER INSERT
AS
BEGIN
    -- Disable the row count
    SET NOCOUNT ON;    

    -- Insert into Loggin table
    INSERT INTO Logs.Loggin (CustomerPassword, CustomerID, SecurityQuestion, SecurityAnswer)
    SELECT
        dbo.GenerateRandomPassword(),
        CustomerKey,
        'How many children do you have?',
        NumberChildrenAtHome
    FROM inserted;

    -- Insert into sentEmails table
    INSERT INTO logs.sentEmails (recipientEmail, emailMessage, EmailTime)
    SELECT
        EmailAddress,
        'Hello. We sent this email to inform you that a new login access has been created with this email. Your corresponding password is ' + CAST(dbo.GenerateRandomPassword() AS NVARCHAR(200)),
        GETDATE()
    FROM inserted;
END;
GO

-- Drop the stored procedure if it exists
IF OBJECT_ID('dbo.RecoverPassword', 'P') IS NOT NULL
    DROP PROCEDURE dbo.RecoverPassword;
GO


-- Section: Password Recovery
CREATE PROCEDURE dbo.RecoverPassword
    @EmailAddress NVARCHAR(255),
    @SecurityQuestion NVARCHAR(255),
    @SecurityAnswer NVARCHAR(255)
AS
BEGIN
    DECLARE @RecoveredPassword NVARCHAR(255);

    -- Check security question and answer in the Loggin table
    IF EXISTS (
        SELECT 1
        FROM Logs.Loggin l
        WHERE l.CustomerID = (
            SELECT CustomerKey
            FROM Person.Customer
            WHERE EmailAddress = @EmailAddress
        )
        AND l.SecurityQuestion = @SecurityQuestion
        AND l.SecurityAnswer = @SecurityAnswer
    )
    BEGIN
        -- Generate a new password
        SET @RecoveredPassword = CAST(dbo.GenerateRandomPassword() AS NVARCHAR(255));

        -- Update the password in the Loggin table
        UPDATE Logs.Loggin
        SET CustomerPassword = @RecoveredPassword
        WHERE CustomerID = (
            SELECT CustomerKey
            FROM Person.Customer
            WHERE EmailAddress = @EmailAddress
        );

        -- Logic to send recovery email
        INSERT INTO logs.sentEmails (recipientEmail, emailMessage, EmailTime)
        SELECT
            @EmailAddress,
            'Hello. We sent this email to inform you that you requested password recovery. Your new password is ' + @RecoveredPassword,
            GETDATE();

			 PRINT 'Recovery email sent successfully.';
    END
    ELSE
    BEGIN
        PRINT 'There was an error.';
    END;
END;
GO





-- Test Query
SELECT TOP 1 CustomerPassword
FROM Logs.Loggin
WHERE CustomerID = (
    SELECT CustomerKey
    FROM Person.Customer
    WHERE EmailAddress = 'ben2@adventure-works.com'
)
ORDER BY LogID DESC;

-- Test Procedure Execution
EXEC dbo.RecoverPassword 'ben2@adventure-works.com', 'Quantos filhos tem?', '3';


-- Select all sent emails and order by time
SELECT *
FROM logs.sentEmails
ORDER BY EmailTime DESC;

