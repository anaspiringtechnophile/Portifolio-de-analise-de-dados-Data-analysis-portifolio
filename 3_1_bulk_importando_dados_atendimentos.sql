
-- Ative o banco antes de executar cada query

USE db_portaria;
GO

-- Importanto dados de atendimento da planilha

BULK INSERT fatos_atendimentos
FROM '/tmp/fatos_atendimentos.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO

