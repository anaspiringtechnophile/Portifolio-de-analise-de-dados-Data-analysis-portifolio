
-- Cálculo do Impacto Económico Real (Anual)

SELECT 
    (SELECT custo_total_anual FROM dim_custos_funcionarios WHERE cenario = 'Atual') AS custo_atual_anual,
    (SELECT custo_total_anual FROM dim_custos_funcionarios WHERE cenario = 'Proposto') AS custo_proposto_anual,
    ((SELECT custo_total_anual FROM dim_custos_funcionarios WHERE cenario = 'Atual') - 
     (SELECT custo_total_anual FROM dim_custos_funcionarios WHERE cenario = 'Proposto')) AS economia_anual_gerada,
    ROUND((((SELECT custo_total_anual FROM dim_custos_funcionarios WHERE cenario = 'Atual') - 
      (SELECT custo_total_anual FROM dim_custos_funcionarios WHERE cenario = 'Proposto')) / 
      (SELECT custo_total_anual FROM dim_custos_funcionarios WHERE cenario = 'Atual')) * 100, 2) AS percentual_economia;

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
        WHEN EXTRACT(HOUR FROM CAST(data_hora AS TIMESTAMP)) BETWEEN 6 AND 8 THEN '06h - 08:30h (Pico Manhã)'
        WHEN EXTRACT(HOUR FROM CAST(data_hora AS TIMESTAMP)) BETWEEN 9 AND 15 THEN '08:30h - 16:30h (Administrativo)'
        WHEN EXTRACT(HOUR FROM CAST(data_hora AS TIMESTAMP)) BETWEEN 16 AND 18 THEN '16:30h - 19:00h (Pico Tarde/Saída)'
        ELSE 'Outros Horários'
    END AS bloco_horario,
    categoria_atividade,
    COUNT(id_atendimento) AS total_atendimentos,
    ROUND(AVG(tempo_atendimento_min), 1) AS tempo_medio_atendimento_min
FROM fatos_atendimentos
GROUP BY 1, categoria_atividade
ORDER BY bloco_horario, total_atendimentos DESC;

