
-- Drop the table if it exists
IF OBJECT_ID('SchemaHistory', 'U') IS NOT NULL
    DROP TABLE SchemaHistory;

-- Criação da tabela para armazenar as informações do esquema
CREATE TABLE SchemaHistory (
    ChangeDate DATETIME,
    TableName NVARCHAR(255),
    ColumnName NVARCHAR(255),
    DataType NVARCHAR(50),
    MaxLength INT,
    IsNullable BIT,
    IsPrimaryKey BIT,
    IsForeignKey BIT,
    ReferencedTable NVARCHAR(255)
);
GO

-- Drop the procedure if it exists
IF OBJECT_ID('dbo.GenerateSchemaHistory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GenerateSchemaHistory;
GO

-- Stored Procedure para gerar entradas na tabela de histórico do esquema
CREATE PROCEDURE dbo.GenerateSchemaHistory
AS
BEGIN
    -- Limpa a tabela de histórico antes de inserir novos registros
    TRUNCATE TABLE SchemaHistory;

    -- Insere informações sobre todas as tabelas e colunas no histórico
    INSERT INTO SchemaHistory
    SELECT
        GETDATE() AS ChangeDate,
        t.name AS TableName,
        c.name AS ColumnName,
        ty.name AS DataType,
        c.max_length AS MaxLength,
        c.is_nullable AS IsNullable,
        CASE WHEN ic.column_id IS NOT NULL THEN 1 ELSE 0 END AS IsPrimaryKey,
        CASE WHEN fc.parent_column_id IS NOT NULL THEN 1 ELSE 0 END AS IsForeignKey,
        rt.name AS ReferencedTable
    FROM
        sys.tables t
    INNER JOIN
        sys.columns c ON t.object_id = c.object_id
    INNER JOIN
        sys.types ty ON c.system_type_id = ty.system_type_id AND c.user_type_id = ty.user_type_id
    LEFT JOIN
        sys.indexes i ON t.object_id = i.object_id AND i.is_primary_key = 1
    LEFT JOIN
        sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id AND c.column_id = ic.column_id
    LEFT JOIN
        sys.foreign_keys fk ON t.object_id = fk.parent_object_id
    LEFT JOIN
        sys.foreign_key_columns fc ON fk.object_id = fc.constraint_object_id AND c.column_id = fc.parent_column_id
    LEFT JOIN
        sys.tables rt ON fc.referenced_object_id = rt.object_id
END;
GO

EXEC dbo.GenerateSchemaHistory;

SELECT * FROM  SchemaHistory;

GO




-- Drop the table if it exists
IF OBJECT_ID('TableStatisticsHistory', 'U') IS NOT NULL
    DROP TABLE TableStatisticsHistory;
GO

-- Create table to store table statistics history
CREATE TABLE TableStatisticsHistory (
    ExecutionDate DATETIME,
    TableName NVARCHAR(255),
    RecordCount INT,
    SpaceUsedKB INT
);
GO

-- Drop the procedure if it exists
IF OBJECT_ID('dbo.UpdateTableStatistics', 'P') IS NOT NULL
    DROP PROCEDURE dbo.UpdateTableStatistics;
GO

-- Stored Procedure to update table statistics and maintain history
CREATE PROCEDURE dbo.UpdateTableStatistics
AS
BEGIN
    -- Declare variables
    DECLARE @tableName NVARCHAR(255)
    DECLARE @sql NVARCHAR(MAX)

    -- Create a temporary table to store current statistics
    CREATE TABLE #TempTableStatistics (
        Name NVARCHAR(100),
        Rows INT,
        Reserved NVARCHAR(100),
        Data NVARCHAR(100),
        Index_Size NVARCHAR(100),
        Unused NVARCHAR(100)
    );

    -- Iterate through each table in the database
    DECLARE tableCursor CURSOR FOR
    SELECT t.name
    FROM sys.tables t;

    OPEN tableCursor;
    FETCH NEXT FROM tableCursor INTO @tableName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Generate dynamic SQL to get table statistics using sp_spaceused
        SET @sql = N'
            INSERT INTO #TempTableStatistics
            EXEC sp_spaceused ''' + @tableName + ''';
        ';

        -- Execute dynamic SQL
        EXEC sp_executesql @sql;

        -- Insert relevant data into the #TempTableStatistics table
        INSERT INTO #TempTableStatistics (Name, Rows)
        SELECT Name, Rows FROM #TempTableStatistics;

        -- Clear the temporary table for the next iteration
        DELETE FROM #TempTableStatistics;

        FETCH NEXT FROM tableCursor INTO @tableName;
    END

    -- Insert results into history table
    INSERT INTO TableStatisticsHistory
    SELECT
        GETDATE() AS ExecutionDate,
        Name AS TableName,
        Rows AS RecordCount,
        CAST(LEFT(Data, LEN(Data) - 3) AS INT) AS SpaceUsedKB
    FROM
        #TempTableStatistics;

    -- Drop temporary table
    DROP TABLE #TempTableStatistics;

    -- Close and deallocate the cursor
    CLOSE tableCursor;
    DEALLOCATE tableCursor;
END;
GO

-- Execute the stored procedure
EXEC dbo.UpdateTableStatistics;

-- View the table statistics history
SELECT * FROM TableStatisticsHistory;
