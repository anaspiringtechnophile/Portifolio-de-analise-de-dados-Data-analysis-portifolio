# Otimização Operacional e Análise de Custos - Portaria Inteligente

## Sobre o Projeto
Este projeto foi desenvolvido para simular e analisar o impacto financeiro e operacional da automação da portaria de uma planta industrial. Através da centralização de dados e da criação de um ecossistema analítico, transformamos dados brutos de acessos, atendimentos e custos de pessoal em insights estratégicos para a tomada de decisão.

## O Problema de Negócio
A gestão da fábrica identificou três grandes desafios na operação da portaria atual:

1. **Custos Elevados de Pessoal:** Alto gasto com postos de trabalho físicos para controle de acesso 24/7.
2. **Lentidão no Embarque de Fretados:** Longas filas e atrasos na validação manual de funcionários nos ônibus fretados.
3. **Gargalos de Atendimento:** Falta de previsibilidade sobre os horários de pico e o tempo gasto em atividades burocráticas (como cadastro de terceiros e entrega de crachás).

## Solução Técnica e Arquitetura de Dados

Para garantir um ambiente moderno, escalável e isolado, toda a infraestrutura do projeto foi desenhada utilizando containers:

* **Sistema Operacional Base:** Linux Ubuntu 24.04 LTS (Ambiente de Desenvolvimento)
* **Banco de Dados:** Microsoft SQL Server 2022 implantado via **Docker**
* **Linguagem de Consulta:** T-SQL (Transact-SQL)
* **Ferramenta de Desenvolvimento:** VS Code

### Modelo de Dados (Data Warehouse)
O banco de dados `db_portaria` foi estruturado seguindo as melhores práticas de modelagem analítica, composto pelas seguintes tabelas:

* **`dim_custos_funcionarios`:** Tabela de dimensão contendo os cenários financeiros (Atual vs. Proposto), salários, encargos e custos totais da equipe de portaria.
* **`fatos_fretados`:** Tabela de fatos com o registro histórico de viagens, métodos de contagem (Manual vs. Digital), passageiros transportados e tempos de embarque.
* **`fatos_atendimentos`:** Tabela de fatos contendo o histórico de interações na portaria, categorias de atividade (crachás, terceiros, afastamentos) e tempos de atendimento.

## Consultas SQL e Insights Extraídos

Abaixo estão as análises estratégicas desenvolvidas para responder às dores do negócio, utilizando técnicas avançadas de manipulação de dados como CTEs (*Common Table Expressions*), conversão de tipos e tratamento de strings.

### 1. Análise do Impacto Econômico Real (Anual)
Esta consulta unifica os cenários financeiros e calcula a economia real gerada pela proposta de automação da portaria.

### Insight de Negócio: 

A reestruturação e automação da portaria reduz os custos operacionais de pessoal em 16,67%, gerando uma economia direta de R$ 25.920,00 por ano para a empresa.


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
FROM CustoNumerico;```


### Impacto do Aplicativo de Leitura de Crachás (Fretados)

Avaliação da eficiência do novo aplicativo digital comparado ao método tradicional de checagem manual utilizando planilhas de papel de passageiros nos ônibus fretados.

```
SELECT 
    metodo_contagem,
    COUNT(id_viagem) AS total_viagens,
    ROUND(AVG(CAST(tempo_embarque_min AS FLOAT)), 1) AS tempo_medio_embarque_minutos,
    ROUND(AVG(CAST(passageiros_contados AS FLOAT)), 1) AS media_passageiros_viagem
FROM fatos_fretados
GROUP BY metodo_contagem;
```

### Insight de Negócio: 

Enquanto o volume de passageiros por viagem permaneceu idêntico (média de ~40 pessoas), o uso do Digital (App) reduziu o tempo médio de embarque de 12,6 para 4,7 minutos — uma redução brutal de 62,7% no tempo de espera, eliminando filas e atrasos logísticos.

### Janelas Operacionais Eficientes (Time-Boxing)
Análise volumétrica e de tempo por bloco de horário para identificar gargalos operacionais e sugerir janelas de atendimento mais inteligentes.

```
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
```

### Insight de Negócio:

O período da manhã é crítico para a liberação de "Crachá/Armário" (244 ocorrências). Atividades demoradas como "Afastamento/RH" e cadastros de "Terceiros" consomem quase 8 minutos por atendimento e concentram-se no horário Administrativo.

### Recomendação Estratégica: 

Restringir atendimentos burocráticos e demorados à janela das 09h às 15:59h, blindando o horário de pico da manhã para garantir a velocidade na entrada dos turnos da fábrica.

## Como Executar o Projeto (Siga o guia)

Se você deseja replicar este ambiente analítico na sua máquina local (Linux/Ubuntu), siga o passo a passo abaixo:

### 1. Subir o Banco de Dados no Docker
Execute o comando abaixo no terminal para baixar a imagem oficial e iniciar o container do SQL Server 2022:

```bash
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=SuaSenhaSegura123!" \
   -p 1433:1433 --name sql_server_demo \
   -d [mcr.microsoft.com/mssql/server:2022-latest](https://mcr.microsoft.com/mssql/server:2022-latest)
```

### Mover os Arquivos de Dados (CSV) para o Container
Com o container rodando, envie os arquivos CSV com os dados operacionais para a pasta /tmp dentro do Docker.

Execute os comando no terminal do seu Ubuntu

`docker cp fatos_fretados.csv sql_server_demo:/tmp/fatos_fretados.csv`
`docker cp fatos_atendimentos.csv sql_server_demo:/tmp/fatos_atendimentos.csv`
`docker cp dim_custos_funcionarios.csv sql_server_demo:/tmp/dim_custos_funcionarios.csv`

Obs: Não esqueça de acessar o container para garantir que cópia dos documentos foram efetivadas.

### Executar os Scripts SQL

Conecte-se ao banco de dados utilizando o VS Code (Host: localhost, Usuário: sa) e execute:

Os scripts de criação das tabelas (CREATE TABLE).

Os comandos de carga em massa (BULK INSERT).

As queries analíticas mapeadas neste documento para visualizar os insights.

Projeto desenvolvido como parte da minha jornada de aprendizado em Engenharia e Análise de Dados.
