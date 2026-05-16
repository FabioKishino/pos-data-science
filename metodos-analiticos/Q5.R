# 1. Carregando a biblioteca e a rede
library(igraph)
g <- make_graph("Zachary")

# ==========================================
# 2. CALCULANDO AS MÉTRICAS DE CENTRALIDADE
# ==========================================

# A. Centralidade de Grau (Degree)
centralidade_grau <- degree(g)

# B. Centralidade de Intermediação (Betweenness)
centralidade_intermediacao <- betweenness(g)

# C. Centralidade de Autovetor (Eigenvector)
# O igraph retorna uma lista, extraímos apenas os valores ($vector)
centralidade_autovetor <- eigen_centrality(g)$vector

# ==========================================
# 3. IDENTIFICANDO OS NÓS VENCEDORES
# ==========================================

no_maior_grau <- which.max(centralidade_grau)
no_maior_intermediacao <- which.max(centralidade_intermediacao)
no_maior_autovetor <- which.max(centralidade_autovetor)

cat("=== OS NÓS MAIS IMPORTANTES ===\n")
cat("Maior Grau (Popularidade): Nó", no_maior_grau, "\n")
cat("Maior Intermediação (Controle de Pontes): Nó", no_maior_intermediacao, "\n")
cat("Maior Autovetor (Influência/Status): Nó", no_maior_autovetor, "\n\n")

# ==========================================
# 4. VISUALIZAÇÃO DO PODER (INTERMEDIAÇÃO)
# ==========================================
# Vamos plotar a rede fazendo com que o tamanho de cada nó 
# seja proporcional à sua centralidade de intermediação.

# Multiplicamos por um fator (ex: 0.5) e somamos uma base (ex: 5) 
# apenas para os nós não ficarem gigantescos ou minúsculos no gráfico.
tamanhos_nos <- (centralidade_intermediacao * 0.4) + 5

# Cores dos nós: Vamos pintar o Nó 1 e o Nó 34 de vermelho para destacá-los, e o resto de azul.
cores_nos <- rep("lightblue", vcount(g))
cores_nos[c(1, 34)] <- "tomato"

plot(g, 
     main = "Importância por Intermediação (Betweenness)",
     vertex.size = tamanhos_nos, 
     vertex.color = cores_nos,
     vertex.label.cex = 0.8,
     vertex.label.color = "black",
     edge.color = "gray80")

