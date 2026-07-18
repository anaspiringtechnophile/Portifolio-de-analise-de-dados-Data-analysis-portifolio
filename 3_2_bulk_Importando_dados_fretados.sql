
-- Query para importar os dados de Fretados

BULK INSERT fatos_fretados
FROM '/tmp/fatos_fretados.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO