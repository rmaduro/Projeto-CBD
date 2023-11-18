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

-- Section: Trigger Definition
-- Drop trigger if it exists
DROP TRIGGER IF EXISTS GenerateLoggin;
GO 

-- Create Trigger
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
        'Quantos filhos tem?',
        NumberChildrenAtHome
    FROM inserted;

    -- Logic to send emails
    -- Insert into sentEmails table
    INSERT INTO logs.sentEmails (recipientEmail, emailMessage, EmailTime)
    SELECT
        EmailAddress,
           'Olá. Mandamos o email para informamar que criou-se um novo acesso de Login com este Email. A sua password corresondente é ' + CAST(dbo.GenerateRandomPassword() AS NVARCHAR(200)),
        GETDATE()
    FROM inserted;
END;
GO
