USE AdventureWorks;
GO

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
    ReferencedTable NVARCHAR(255),
    ForeignKeyAction NVARCHAR(50)
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
        rt.name AS ReferencedTable,
        CASE
		WHEN fk.delete_referential_action_desc IS NOT NULL THEN fk.delete_referential_action_desc
			ELSE 'NO_ACTION' 
		END AS ForeignKeyAction
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

EXEC dbo.GenerateSchemaHistory;

SELECT * FROM  SchemaHistory;
