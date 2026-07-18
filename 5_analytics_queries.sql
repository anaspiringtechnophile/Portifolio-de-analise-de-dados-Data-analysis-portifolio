
-- Ative o banco

USE db_portaria;
GO

-- Cálculo do Impacto Económico Real (Anual)
-- Transformando o texto em número (FLOAT) para podermos calcular depois

SELECT 
    cenario,
        CAST(custo_total_anual AS FLOAT) AS custo_numerico
FROM dim_custos_funcionarios;
GO

-- Criamos a CTE chamada 'CustoNumerico' para organizar os valores já convertidos

WITH CustoNumerico AS (
    SELECT 
        MAX(CASE WHEN cenario = 'Atual' THEN CAST(custo_total_anual AS FLOAT) END) AS custo_atual,
        MAX(CASE WHEN cenario = 'Proposto' THEN CAST(custo_total_anual AS FLOAT) END) AS custo_proposto
    FROM dim_custos_funcionarios
)
SELECT 
    custo_atual AS custo_atual_anual,
    custo_proposto AS custo_proposto_anual,
    (custo_atual - custo_proposto) AS economia_anual_gerada,
    ROUND(((custo_atual - custo_proposto) / custo_atual) * 100, 2) AS percentual_economia
FROM CustoNumerico;
GO

-- Impacto do Aplicativo de Leitura de Crachás (Fretados)

SELECT 
    metodo_contagem,
    COUNT(id_viagem) AS total_viagens,
    ROUND(AVG(tempo_embarque_min), 1) AS tempo_medio_embarque_minutos,
    ROUND(AVG(passageiros_contados), 1) AS media_passageiros_viagem
FROM fatos_fretados
GROUP BY metodo_contagem;

-- Justificação de Janelas de Atendimento (Time-Boxing)

SELECT 
    CASE 
        WHEN CAST(SUBSTRING(data_hora, 12, 2) AS INT) BETWEEN 6 AND 8 THEN '06:00h - 08:59h (Pico Manhã)'
        WHEN CAST(SUBSTRING(data_hora, 12, 2) AS INT) BETWEEN 9 AND 15 THEN '09:00h - 15:59h (Administrativo)'
        WHEN CAST(SUBSTRING(data_hora, 12, 2) AS INT) BETWEEN 16 AND 18 THEN '16:00h - 18:59h (Pico Tarde/Saída)'
        ELSE 'Outros Horários'
    END AS bloco_horario,
    categoria_atividade,
    COUNT(id_atendimento) AS total_atendimentos,
    ROUND(AVG(CAST(tempo_atendimento_min AS FLOAT)), 1) AS tempo_medio_atendimento_min
FROM fatos_atendimentos
GROUP BY 
    CASE 
        WHEN CAST(SUBSTRING(data_hora, 12, 2) AS INT) BETWEEN 6 AND 8 THEN '06:00h - 08:59h (Pico Manhã)'
        WHEN CAST(SUBSTRING(data_hora, 12, 2) AS INT) BETWEEN 9 AND 15 THEN '09:00h - 15:59h (Administrativo)'
        WHEN CAST(SUBSTRING(data_hora, 12, 2) AS INT) BETWEEN 16 AND 18 THEN '16:00h - 18:59h (Pico Tarde/Saída)'
        ELSE 'Outros Horários'
    END, 
    categoria_atividade
ORDER BY bloco_horario, total_atendimentos DESC;
GO