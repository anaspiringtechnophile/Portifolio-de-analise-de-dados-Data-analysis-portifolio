USE db_portaria;
GO


-- Importação usando o parser nativo de CSV do SQL Server

BULK INSERT dim_custos_funcionarios
FROM '/tmp/dim_custos_funcionarios.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO

BULK INSERT fatos_fretados
FROM '/tmp/fatos_fretados.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO

BULK INSERT fatos_atendimentos
FROM '/tmp/fatos_atendimentos.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO

