# 1. Carregando as bibliotecas exigidas
library(igraph)
library(ggplot2)

# 2. Carregando a rede do Clube de Karatê de Zachary (sem pesos)
g <- make_graph("Zachary")

# ==========================================
# CÁLCULOS E PREPARAÇÃO DOS DADOS
# ==========================================

# A. Grau
graus <- degree(g)
df_graus <- data.frame(Grau = graus)

# B. Caminho Mínimo
matriz_distancias <- distances(g)
caminhos_unicos <- matriz_distancias[upper.tri(matriz_distancias)]
df_caminhos <- data.frame(Caminho = caminhos_unicos)

# ==========================================
# GERAÇÃO DOS GRÁFICOS COM RÓTULOS (LABELS)
# ==========================================

# Gráfico da Distribuição de Grau
grafico_grau <- ggplot(df_graus, aes(x = Grau)) +
  geom_bar(fill = "steelblue", color = "black", alpha = 0.8) +
  # Adicionando o texto com a contagem exata no topo de cada coluna
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5, size = 4, fontface = "bold") +
  labs(title = "Distribuição de Grau",
       subtitle = "Clube de Karatê de Zachary (Não Ponderado)",
       x = "Grau (Número de Conexões)",
       y = "Frequência (Nº de Nós)") +
  scale_x_continuous(breaks = min(df_graus$Grau):max(df_graus$Grau)) +
  # Dando um "respiro" de 15% no topo do eixo Y para o número não cortar
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) + 
  theme_minimal()

# Gráfico da Distribuição dos Caminhos Mínimos
grafico_caminho <- ggplot(df_caminhos, aes(x = Caminho)) +
  geom_bar(fill = "darkorange", color = "black", alpha = 0.8) +
  # Adicionando o texto com a contagem exata no topo de cada coluna
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5, size = 4, fontface = "bold") +
  labs(title = "Distribuição dos Caminhos",
       x = "Distância (Número de Arestas)",
       y = "Frequência (Nº de Pares)") +
  scale_x_continuous(breaks = min(df_caminhos$Caminho):max(df_caminhos$Caminho)) +
  # Dando um "respiro" de 15% no topo do eixo Y para o número não cortar
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  theme_minimal()

# ==========================================
# EXIBIÇÃO
# ==========================================
print(grafico_grau)
print(grafico_caminho)

# c
trans_global <- transitivity(g, type = "global")
trans_local  <- transitivity(g, type = "local")

cat("\n-- Coeficiente de Clusterização --\n")
cat("Transitividade Global:        ", round(trans_global, 4), "\n")
cat("Transitividade Local (média): ", round(mean(trans_local, na.rm = TRUE), 4), "\n")

df_trans <- data.frame(no = 1:vcount(g), local = trans_local)

p3 <- ggplot(df_trans, aes(x = local)) +
  geom_histogram(bins = 10, fill = "purple", color = "white") +
  labs(title = "Distribuição do Coeficiente de Clusterização Local",
       x = "Coeficiente de Clusterização", y = "Frequência") +
  theme_minimal()
print(p3)

cat("\n")




