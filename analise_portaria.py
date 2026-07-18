import pandas as pd

# 1. Carregar as tabelas do Excel

excel_path = "projeto_otimizacao_portaria.xlsx"
df_atendimentos = pd.read_excel(excel_path, sheet_name="Fatos Atendimentos")
df_fretados = pd.read_excel(excel_path, sheet_name="Fatos Fretados")

# 2. Exemplo de Engenharia de Atributos (Feature Engineering)
# Extrair a hora do dia para justificar o "Time-Boxing" (Janelas de atendimento)

df_atendimentos['Data/Hora'] = pd.to_datetime(df_atendimentos['Data/Hora'])
df_atendimentos['Hora'] = df_atendimentos['Data/Hora'].dt.hour

# 3. Agrupar por hora para encontrar os períodos de pico na portaria

picos_atendimento = df_atendimentos.groupby('Hora')['Tempo Atendimento (Min)'].count()
print("Volume de Atendimentos por Hora:")
print(picos_atendimento)