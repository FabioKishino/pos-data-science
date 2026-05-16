library(igraph)

# Carregamento do dataset Zachary (integrado no igraph)
# A função make_graph permite carregar redes clássicas diretamente
g_karate <- make_graph("Zachary")

# Removendo pesos para garantir análise puramente topológica
g_karate <- delete_edge_attr(g_karate, "weight")

# Questão 2: Visualização com Fruchterman-Reingold
# Para uma rede pequena, o algoritmo converge rapidamente para uma estrutura clara
l_karate <- layout_with_fr(g_karate)

plot(g_karate, 
     layout = l_karate, 
     vertex.size = 12, 
     # vertex.color = "skyblue",
     vertex.label.cex = 0.7,
     vertex.label.dist = 1.5,
     edge.color = "gray80",
     main = "Clube de Karatê de Zachary (Layout FR)")
library(ggplot2)

# 3a. Grau
deg_k <- degree(g_karate)
ggplot(data.frame(Grau = deg_k), aes(x = Grau)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "Distribuição de Grau (Zachary)", x = "Grau", y = "Frequência")

# 3b. Caminhos Mínimos
paths_k <- distances(g_karate)
hist(paths_k, breaks = max(paths_k), main = "Caminhos Mínimos (Zachary)", 
     xlab = "Distância", col = "lightgreen")

# 3c. Coeficiente de Clusterização
trans_g_k <- transitivity(g_karate, type = "global")
trans_l_k <- mean(transitivity(g_karate, type = "local"), na.rm = TRUE)
print(paste("Global:", round(trans_g_k, 4), "| Local (média):", round(trans_l_k, 4)))


# Execução de todos os algoritmos adequados
cw_k <- cluster_walktrap(g_karate)
cfg_k <- cluster_fast_greedy(g_karate)
cle_k <- cluster_leading_eigen(g_karate)
ceb_k <- cluster_edge_betweenness(g_karate) # Totalmente viável aqui

# Comparação de desempenho via Modularidade
print(data.frame(
  Algoritmo = c("Walktrap", "Fast Greedy", "Leading Eigenvector", "Edge Betweenness"),
  Modularidade = c(modularity(cw_k), modularity(cfg_k), modularity(cle_k), modularity(ceb_k))
))
