-- Atice o banco sempre antes de executar qualquer das queries seguintes

USE db_portaria;
GO

-- Importar os dados de Custos
-- Importação do novo arquivo gerado nativamente no Linux

BULK INSERT dim_custos_funcionarios
FROM '/tmp/dim_custos_funcionarios.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO

