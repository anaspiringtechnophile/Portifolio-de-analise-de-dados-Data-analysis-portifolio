-- 1. Criar tabela de Custos (se já existir, não tem problema)

CREATE TABLE dim_custos_funcionarios (
    cenario NVARCHAR(250),
    quantidade_porteiros NVARCHAR(250),
    salario_nominal NVARCHAR(250),
    encargos_estimados NVARCHAR(250),
    custo_total_mensal NVARCHAR(250),
    custo_total_anual NVARCHAR(250)
);
GO

-- 2. Criar tabela de Fretados

IF OBJECT_ID('fatos_fretados', 'U') IS NULL
BEGIN
    CREATE TABLE fatos_fretados (
        id_viagem INT,
        data DATE,
        periodo VARCHAR(20),
        metodo_contagem VARCHAR(50),
        passageiros_contados INT,
        tempo_embarque_min INT
    );
END;
GO

-- 3. Criar tabela de Atendimentos

CREATE TABLE fatos_atendimentos (
    id_atendimento VARCHAR(50),
    data_hora VARCHAR(100),
    categoria_atividade VARCHAR(250),
    tempo_atendimento_min VARCHAR(50),
    porteiro_responsavel VARCHAR(250)
);
GO

