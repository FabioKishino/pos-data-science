# 1. Carregando a biblioteca e a rede
library(igraph)
g <- make_graph("Zachary")

# ==========================================
# 2. CÁLCULO DO DIÂMETRO
# ==========================================

# Calculando o valor numérico do diâmetro (quantos saltos)
valor_diametro <- diameter(g)

# Extraindo a sequência exata de nós que compõem esse caminho
caminho_diametro <- get_diameter(g)

cat("=== DIÂMETRO DA REDE ===\n")
cat("O diâmetro do clube é de", valor_diametro, "saltos.\n")
cat("A rota extrema passa pelos nós:", as.numeric(caminho_diametro), "\n\n")

# ==========================================
# 3. VISUALIZAÇÃO DO CAMINHO EXTREMO
# ==========================================

# Preparando as cores padrão (Nós azuis, arestas cinzas)
V(g)$color <- "lightblue"
E(g)$color <- "gray80"
E(g)$width <- 1

# Destacando os nós que fazem parte do diâmetro (em vermelho)
V(g)[caminho_diametro]$color <- "tomato"

# Destacando as arestas que ligam esse caminho (em vermelho e mais grossas)
# A função E(g, path=...) pega exatamente as arestas que conectam uma sequência de nós
E(g, path = caminho_diametro)$color <- "red"
E(g, path = caminho_diametro)$width <- 3

plot(g, 
     main = paste("Diâmetro da Rede: Caminho mais longo (", valor_diametro, " saltos)"),
     vertex.size = 15, 
     vertex.label.cex = 0.8,
     vertex.label.color = "black")
