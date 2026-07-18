
-- Ative o banco antes de executar as queries abaixo

USE db_portaria;
GO

-- Criar a tabela de Fretados se ela não existir

IF OBJECT_ID('fatos_fretados', 'U') IS NULL
BEGIN
    CREATE TABLE fatos_fretados (
        id_viagem INT,
        data DATE,
        periodo VARCHAR(50),
        metodo_contagem VARCHAR(100),
        passageiros_contados INT,
        tempo_embarque_min INT
    );
    PRINT 'Tabela fatos_fretados criada com sucesso!';
END
ELSE
BEGIN
    PRINT 'A tabela fatos_fretados já existe no banco.';
END;
GO

-- Criar a tabela de Atendimentos se ela não existir
-- Armazena como texto para garantir uma importação sem falhas data_hora VARCHAR(100), 


IF OBJECT_ID('fatos_atendimentos', 'U') IS NULL
BEGIN
    CREATE TABLE fatos_atendimentos (
        id_atendimento VARCHAR(50),
        data_hora VARCHAR(100),
        categoria_atividade VARCHAR(250),
        tempo_atendimento_min INT,
        porteiro_responsavel VARCHAR(250)
    );
    PRINT 'Tabela fatos_atendimentos criada com sucesso!';
END
ELSE
BEGIN
    PRINT 'A tabela fatos_atendimentos já existe no banco.';
END;
GO

-- Criar a tabela de Custos com tipos textuais tolerantes

IF OBJECT_ID('dim_custos_funcionarios', 'U') IS NULL
BEGIN
    CREATE TABLE dim_custos_funcionarios (
        cenario NVARCHAR(250),
        quantidade_porteiros NVARCHAR(250),
        salario_nominal NVARCHAR(250),
        encargos_estimados NVARCHAR(250),
        custo_total_mensal NVARCHAR(250),
        custo_total_anual NVARCHAR(250)
    );
    PRINT 'Tabela dim_custos_funcionarios criada com sucesso!';
END
ELSE
BEGIN
    PRINT 'A tabela dim_custos_funcionarios já existe no banco.';
END;
GO