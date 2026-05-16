# Importação das bibliotecas essenciais
library(igraph)
library(ggplot2)

# Carregamento dos dados brutos
edges <- read.table("e_coli/e_coli.net", col.names = c("src", "dest", "type"))
nodes <- read.table("e_coli/e_coli_nodes.txt", col.names = c("id", "gene_name"))

# Construção do objeto igraph
# O parâmetro 'directed = TRUE' é crucial, pois a regulação é unidirecional na biologia
g <- graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)

V(g)$name <- V(g)$gene_name # Define o nome oficial do vértice

# Adicionando o tipo de interação como atributo de borda categórico
E(g)$type_label <- ifelse(E(g)$type == 1, "Ativador", 
                          ifelse(E(g)$type == 2, "Repressor", "Dual"))


# Plotagem utilizando o layout Fruchterman-Reingold
plot(g, 
     layout = layout_with_fr(g), 
     vertex.size = 4, 
     vertex.label = NA, # Rótulos ocultos para evitar poluição visual
     edge.arrow.size = 0.3,
     # edge.color = c("blue", "red", "purple")[E(g)$type], # Diferenciando o tipo de regulação
     main = "E. coli (layout Fruchterman-Reingold)")

# Cálculo do grau (total, in e out)
grau_out <- degree(g, mode = "out")

# Distribuição com ggplot2
df_grau <- data.frame(Grau = grau_out)
ggplot(df_grau, aes(x = Grau)) + 
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribuição de Grau (E. coli)", x = "Grau", y = "Frequência")

# Matriz de distâncias e extração dos caminhos válidos
dist_mat <- distances(g, mode = "out")
caminhos_validos <- dist_mat[dist_mat != Inf & dist_mat > 0]


grafico_caminho <- ggplot(df_caminhos, aes(x = Caminho)) +
  geom_bar(fill = "darkorange", color = "black", alpha = 0.9) +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5, size = 4, fontface = "bold") +
  labs(title = "Distribuição dos Caminhos (AIDS blog)",
       x = "Distância (Número de Arestas)",
       y = "Frequência (Nº de Pares)") +
  scale_x_continuous(breaks = min(df_caminhos$Caminho):max(df_caminhos$Caminho)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  theme_minimal()

grafico_caminho

# Transitividade global
trans_global <- transitivity(g, type = "global")
print(paste("Coeficiente de Clusterização Global:", round(trans_global, 4)))

trans_local  <- transitivity(g, type = "local")
cat("Transitividade Local (média): ", round(mean(trans_local, na.rm = TRUE), 4), "\n")


# Detecção de comunidades via Walktrap
comunidades <- cluster_walktrap(g)
print(paste("Número de comunidades detectadas:", length(comunidades)))

# Modularidade 
# Correção: a variável gerada acima chama-se 'comunidades' e não 'com_walktrap'
mod <- modularity(comunidades)
print(paste("Modularidade:", mod))


# Cálculo de Betweenness
bet <- betweenness(g, directed = TRUE)
no_prestigio <- V(g)$gene_name[which.max(bet)]
print(paste("Nó de maior prestígio (Betweenness):", no_prestigio))

# Cálculo de Edge Betweenness
edge_bet <- edge_betweenness(g, directed = TRUE)
aresta_critica_idx <- which.max(edge_bet)

# Extrai os nós da aresta (agora retorna uma matriz com os nomes diretos)
aresta_critica <- ends(g, aresta_critica_idx)

# Correção: Como ends() retorna uma matriz de 1 linha e 2 colunas com os nomes,
# basta acessar [1, 1] e [1, 2] diretamente.
print(paste("Aresta crítica:", aresta_critica[1, 1], "->", aresta_critica[1, 2]))


diametro <- diameter(g, directed = TRUE)
print(paste("Diâmetro da rede:", diametro))

