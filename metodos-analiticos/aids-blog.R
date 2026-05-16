# Importação das bibliotecas essenciais
library(igraph)
library(ggplot2)

# Carregamento dos dados brutos (apenas source e dest)
edges <- read.table("aids-blog/AIDSBlog.txt", col.names = c("src", "dest"))

# Construção do objeto igraph (sem pesos/tipos)
# O parâmetro 'directed = TRUE' é crucial, pois um link em um blogroll é unidirecional
g <- graph_from_data_frame(d = edges, directed = TRUE)

# Garantir que os nomes dos vértices sejam os próprios IDs lidos do arquivo
V(g)$name <- V(g)$name 

# Plotagem utilizando o layout Fruchterman-Reingold
plot(g, 
     layout = layout_with_fr(g), 
     vertex.size = 5, 
     vertex.label = NA, # Rótulos ocultos para evitar poluição visual
     edge.arrow.size = 0.3,
     edge.color = "gray50",
     main = "AIDS Blogs (layout Fruchterman-Reingold)")

# Cálculo do grau (total, in e out)
grau_out <- degree(g, mode = "out")

# Distribuição com ggplot2
df_grau <- data.frame(Grau = grau_out)
ggplot(df_grau, aes(x = Grau)) + 
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribuição de Grau (AIDS Blogs)", x = "Grau", y = "Frequência")

# Matriz de distâncias e extração dos caminhos válidos
dist_mat <- distances(g, mode = "out")
caminhos_validos <- dist_mat[dist_mat != Inf & dist_mat > 0]

df_caminhos <- data.frame(Caminho = caminhos_validos)
ggplot(df_caminhos, aes(x = Caminho)) + 
  geom_bar(fill = "coral", color = "black") +
  theme_minimal() +
  labs(title = "Distribuição dos Caminhos Mínimos", x = "Comprimento do Caminho", y = "Frequência")

# Transitividade global
trans_global <- transitivity(g, type = "global")
print(paste("Coeficiente de Clusterização Global:", round(trans_global, 4)))

trans_local  <- transitivity(g, type = "local")
cat("Transitividade Local (média): ", round(mean(trans_local, na.rm = TRUE), 4), "\n")

# Detecção de comunidades via Walktrap
comunidades <- cluster_walktrap(g)
print(paste("Número de comunidades detectadas:", length(comunidades)))

# Modularidade 
mod <- modularity(comunidades)
print(paste("Modularidade:", mod))


# Importação das bibliotecas
library(igraph)
library(ggplot2)

# Carregamento dos dados
edges <- read.table("AIDSBlog.txt", col.names = c("src", "dest"))
g <- graph_from_data_frame(d = edges, directed = TRUE) # Rede direcionada 
V(g)$name <- V(g)$name 

# Questão 4: Comparação de Algoritmos (Apenas os compatíveis com redes direcionadas)
com_walktrap <- cluster_walktrap(g)
com_edge_betweenness <- cluster_edge_betweenness(g)

# Criando o Data Frame de resultados
resultados <- data.frame(
  Algoritmo = c("Walktrap", "Edge Betweenness"),
  Modularidade = c(
    modularity(com_walktrap),
    modularity(com_edge_betweenness)
  ),
  Qtd_Comunidades = c(
    length(com_walktrap),
    length(com_edge_betweenness)
  )
)

# Ordenando pelo melhor (maior modularidade)
resultados_ordenados <- resultados[order(-resultados$Modularidade), ]

print("Comparação de Agrupamentos (Algoritmos Direcionados):")
print(resultados_ordenados)

# Seleção do vencedor
melhor_algoritmo <- resultados_ordenados$Algoritmo[1]
if(melhor_algoritmo == "Walktrap") {
  melhor_comunidade <- com_walktrap
} else {
  melhor_comunidade <- com_edge_betweenness
}

# Plotagem do melhor agrupamento
plot(melhor_comunidade, g, 
     main = paste("Melhor Agrupamento (AIDS Blogs):", melhor_algoritmo),
     vertex.size = 10, 
     vertex.label = NA,
     edge.arrow.size = 0.2,
     edge.color = "gray80")

# Cálculo de Betweenness
bet <- betweenness(g, directed = TRUE)
no_prestigio <- V(g)$name[which.max(bet)]
print(paste("Nó de maior prestígio (Betweenness):", no_prestigio))

# Cálculo de Edge Betweenness
edge_bet <- edge_betweenness(g, directed = TRUE)
aresta_critica_idx <- which.max(edge_bet)

# Extrai os nós da aresta 
aresta_critica <- ends(g, aresta_critica_idx)
print(paste("Aresta crítica:", aresta_critica[1, 1], "->", aresta_critica[1, 2]))

# Diâmetro
diametro <- diameter(g, directed = TRUE)
print(paste("Diâmetro da rede:", diametro))
