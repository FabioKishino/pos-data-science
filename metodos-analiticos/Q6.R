# 1. Carregando a biblioteca e a rede
library(igraph)
g <- make_graph("Zachary")

# ==========================================
# 2. CALCULANDO A IMPORTÂNCIA DAS ARESTAS
# ==========================================

# Calculando o Edge Betweenness para todas as arestas
intermediacao_arestas <- edge_betweenness(g)
print(intermediacao_arestas)

# Encontrando o índice da aresta com o maior valor
indice_maior_aresta <- which.max(intermediacao_arestas)

# Extraindo quem são os dois nós que essa aresta conecta
aresta_vencedora <- E(g)[indice_maior_aresta]
nos_conectados <- ends(g, aresta_vencedora)

cat("=== A ARESTA MAIS IMPORTANTE ===\n")
cat("Ela atua como a maior ponte da rede, conectando o Nó", nos_conectados[1], "ao Nó", nos_conectados[2], "\n\n")

# ==========================================
# 3. VISUALIZAÇÃO DAS PONTES
# ==========================================
# Vamos deixar a espessura de todas as arestas proporcional à sua importância.
# Arestas mais "gordas" são pontes críticas. Arestas finas são conexões comuns.

# Normalizando as espessuras para o gráfico não ficar bagunçado (valores entre 1 e 5)
espessuras <- (intermediacao_arestas / max(intermediacao_arestas)) * 5 
E(g)$width <- espessuras

# Pintando todas as arestas de cinza claro
E(g)$color <- "gray80"

# Destacando a aresta vencedora (a mais importante de todas) em vermelho e mais grossa
E(g)$color[indice_maior_aresta] <- "red"
E(g)$width[indice_maior_aresta] <- 7 

plot(g, 
     main = "Importância das Arestas (Edge Betweenness)",
     vertex.size = 12, 
     vertex.color = "lightblue",
     vertex.label.cex = 0.8,
     vertex.label.color = "black")

