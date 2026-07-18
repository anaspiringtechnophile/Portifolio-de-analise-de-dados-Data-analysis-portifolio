
--Ative o banco antes de executar a query abaixo

USE db_portaria;
GO

-- Query para testar a efetivação da tabala fato_fretados

SELECT * FROM fatos_fretados;

-- Query para conferir se os dados foram inseridos com sucesso

SELECT TOP 5 * FROM fatos_fretados;

-- Query para testar a efetivação da tabela fato_atendimentos

SELECT * FROM fatos_atendimentos;

-- Query para conferir se os dados foram inseridos com sucesso

SELECT TOP 5 * FROM fatos_atendimentos;

-- Query para testar a efetivação da tabela dim_custos_funcionarios

SELECT * FROM dim_custos_funcionarios;
