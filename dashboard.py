import streamlit as st
import pandas as pd
from datetime import datetime

st.set_page_config(page_title="Pos - Data Science")

df = pd.read_csv('TB_RH.csv', sep=';')

st.write('# Análise de Dados dos Servidores Públicos do Estado do Paraná')
st.caption('Por: Fabio Kishino (11/Ago/2025)')
st.write('O dataset escolhido para o trabalho é referente ao [portal da transparência do estado do Paraná](https://www.transparencia.pr.gov.br/pte/pessoal/servidores/poderexecutivo/remuneracao?windowId=fa9) e ele possui informações sobre remuneração, cargo e local de trabalho dos servidores civis e militares - Ativos, Aposentados, da Reserva e Reformados, Pensionistas e beneficiários de Pensões Especiais, e de ex-Servidores - do Poder Executivo do Estado do Paraná, desde 2012, estão aqui.')
st.write('Ele possui um total de 871713 registros e contém as seguintes colunas: cod_vinculo, nome, sigla, instituicao, lotacao, municipio, cargo, dt_inicio, dt_fim, regime, quadro_funcional, quadro_funcional_desc, tipo_cargo, situacao, ult_remu_bruta, genero, ano_nasc e atualizado.')
st.download_button('Baixar Dataset', data=df.to_csv().encode('utf-8'), file_name='TB_RH.csv', mime='text/csv')

df.columns = df.columns.str.upper()

df = df.rename(columns={
  'DT_INICIO': 'DATA_INICIO',
  'DT_FIM': 'DATA_FIM',
  'ULT_REMU_BRUTA': 'ULTIMA_REMUNERACAO_BRUTA',
  'ANO_NASC': 'ANO_NASCIMENTO',
})

df_ativos = df[df['SITUACAO'] == 'ATIVO']

# Calcular a idade dos servidores
current_year = datetime.now().year
df_ativos['IDADE'] = current_year - df_ativos['ANO_NASCIMENTO']

df_ativos = df_ativos[['NOME', 'SIGLA', 'INSTITUICAO', 'LOTACAO', 'MUNICIPIO', 'CARGO', 'DATA_INICIO', 'REGIME', 'QUADRO_FUNCIONAL', 'QUADRO_FUNCIONAL_DESC', 'TIPO_CARGO', 'SITUACAO', 'ULTIMA_REMUNERACAO_BRUTA', 'GENERO', 'IDADE','ANO_NASCIMENTO', 'ATUALIZADO']]


st.write('Mas para fins de análise, utilizaremos apenas os dados dos **servidores ativos:**')

choice = st.multiselect(
    'Selecione os municípios:',
    options=df_ativos['MUNICIPIO'].unique()
)

if choice:
    st.write(df_ativos[df_ativos['MUNICIPIO'].isin(choice)])
else:
    st.write(df_ativos)

st.divider()

st.write('## Análise Exploratória dos Dados')

# Removendo Outliers da Última Remuneração Bruta
q3 = df_ativos['ULTIMA_REMUNERACAO_BRUTA'].quantile(0.03)
q97 = df_ativos['ULTIMA_REMUNERACAO_BRUTA'].quantile(0.97)
df_ativos_filtrado = df_ativos[(df_ativos['ULTIMA_REMUNERACAO_BRUTA'] >= q3) & (df_ativos['ULTIMA_REMUNERACAO_BRUTA'] <= q97)]

# Filtragem de dados 
df_ativos_filtrado = df_ativos_filtrado[df_ativos_filtrado['CARGO'] != '****'] 
df_top_cargos = df_ativos_filtrado.groupby('CARGO').size().sort_values(ascending=False).head(10)
df_top_cargos = df_top_cargos.rename("QUANTIDADE")

st.write('### Top 10 Cargos com mais servidores ativos no PR')
st.bar_chart(df_top_cargos, x_label='Quantidade', y_label='Cargo', horizontal=True, color="#1fb462")

st.divider()

df_ativos_filtrado_professores = df_ativos_filtrado[df_ativos_filtrado['CARGO'] == 'PROFESSOR']
df_professores_idade = df_ativos_filtrado_professores.groupby('IDADE')['ULTIMA_REMUNERACAO_BRUTA'].mean().reset_index()
df_professores_idade = df_professores_idade.rename(columns={'IDADE': 'Idade', 'ULTIMA_REMUNERACAO_BRUTA': 'Remuneração Bruta média (R$)'})

st.write('### Evolução da Remuneração Média Bruta dos Professores de Curitiba com base na idade')
st.line_chart(df_professores_idade, x='Idade', y='Remuneração Bruta média (R$)', color="#1fb462")
