# Carregar a biblioteca necessária
library(igraph)

# 1. Importação da lista de arestas (e_coli.net)
# O arquivo não possui cabeçalho e as colunas são: De, Para, Tipo
edges <- read.table("e_coli/e_coli.net", col.names = c("from", "to", "type"))

# 2. Importação do mapeamento de nós (e_coli_nodes.txt)
# O arquivo contém o ID do nó e o nome do gene correspondente
nodes <- read.table("e_coli/e_coli_nodes.txt", col.names = c("id", "gene_name"), stringsAsFactors = FALSE)

# 3. Criação do objeto de grafo no igraph
# Como os IDs no arquivo começam em 0, garantimos a integridade referencial
g_ecoli <- graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)

print(g_ecoli)

# Visualização
# Layout de força para destacar agrupamentos
plot(g_ecoli, 
     layout = layout_with_fr, 
     vertex.size = 3, 
     vertex.label = NA, 
     edge.arrow.size = 0.2,
     main = "Layout Fruchterman-Reingold (Clusters)")

# Layout em camadas para visualizar a hierarquia de regulação
plot(g_ecoli, 
     layout = layout_with_sugiyama(g_ecoli)$layout, 
     vertex.size = 3, 
     vertex.label = NA, 
     edge.arrow.size = 0.2,
     main = "Layout Sugiyama (Hierarquia)")

# Layout circular para visão geral da densidade
plot(g_ecoli, 
     layout = layout_in_circle, 
     vertex.size = 3, 
     vertex.label = NA, 
     edge.arrow.size = 0.2,
     main = "Layout Circular (Conectividade Global)")

# Definindo cores: 1 (Ativador) = Verde, 2 (Repressor) = Vermelho, 3 (Dual) = Azul
edge_colors <- c("green", "red", "blue")[E(g_ecoli)$type]

plot(g_ecoli, 
     layout = layout_with_fr, 
     vertex.size = 3, 
     vertex.label = NA, 
     edge.color = edge_colors, 
     edge.arrow.size = 0.2)

# Questao 03
# Distribuição de Grau (In, Out e Total)
# ==========================================
# CÁLCULOS E PREPARAÇÃO DOS DADOS (E. coli)
# ==========================================

# A. Grau
# Calculamos o grau total (in + out) para manter a lógica do exemplo anterior
graus <- degree(g_ecoli)
df_graus <- data.frame(Grau = graus)

# B. Caminho Mínimo
# Sendo uma rede direcionada, muitos pares de nós não se alcançam (distância infinita).
# Filtramos apenas caminhos finitos e maiores que zero (excluindo a distância do nó para ele mesmo).
matriz_distancias <- distances(g_ecoli, mode = "out")
caminhos_finitos <- matriz_distancias[is.finite(matriz_distancias) & matriz_distancias > 0]
df_caminhos <- data.frame(Caminho = caminhos_finitos)

# ==========================================
# GERAÇÃO DOS GRÁFICOS COM RÓTULOS (LABELS)
# ==========================================

# Gráfico da Distribuição de Grau
grafico_grau <- ggplot(df_graus, aes(x = Grau)) +
  geom_bar(fill = "steelblue", color = "black", alpha = 0.8) +
  # Adicionando o texto com a contagem exata no topo
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5, size = 3, fontface = "bold") +
  labs(title = "Distribuição de Grau",
       subtitle = "Rede de Regulação Transcricional - E. coli",
       x = "Grau (Número de Conexões)",
       y = "Frequência (Nº de Genes)") +
  # Como o grau vai até 72, usamos intervalos de 5 para não sobrepor os números no eixo X
  scale_x_continuous(breaks = seq(0, max(df_graus$Grau), by = 5)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) + 
  theme_minimal()

# Gráfico da Distribuição dos Caminhos Mínimos
grafico_caminho <- ggplot(df_caminhos, aes(x = Caminho)) +
  geom_bar(fill = "darkorange", color = "black", alpha = 0.8) +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5, size = 4, fontface = "bold") +
  labs(title = "Distribuição dos Caminhos (e-coli)",
       x = "Distância (Número de Arestas)",
       y = "Frequência (Nº de Pares)") +
  scale_x_continuous(breaks = min(df_caminhos$Caminho):max(df_caminhos$Caminho)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  theme_minimal()

# ==========================================
# EXIBIÇÃO
# ==========================================
print(grafico_grau)
print(grafico_caminho)

# Transitividade Global (Proporção de triângulos fechados)
transitivity(g_ecoli, type = "global")

# Coeficiente de Clusterização Local (Média)
mean(transitivity(g_ecoli, type = "local"), na.rm = TRUE)
