# Carregamento de pacotes
library(igraph)
library(ggplot2)

# Carregamento da rede
g <- read_graph("power/power.gml", format = "gml")

# Verificação inicial
summary(g) # IGRAPH UN-- 4941 6594 --

# Ocultando os nós e arestas para focar na macroestrutura
l <- layout_with_lgl(g)
plot(g, layout = l, vertex.size = 2, vertex.label = NA, 
     edge.width = 0.5, edge.color = "gray80",
     main = "Western States Power Grid (LGL)")

# 3a. Grau
deg <- degree(g)
deg_dist <- as.data.frame(table(deg))
deg_dist$deg <- as.numeric(as.character(deg_dist$deg))

ggplot(deg_dist, aes(x = deg, y = Freq)) +
  geom_point(color = "steelblue", size = 2) + scale_y_log10() + scale_x_log10() +
  labs(title = "Distribuição de Grau (Log-Log)", x = "Grau", y = "Frequência")

ggplot(deg_dist, aes(x = deg, y = Freq)) +
  geom_point(color = "steelblue", size = 2) +
  scale_y_log10() +
  scale_x_log10() +
  labs(
    title = "Distribuição de Grau (Log-Log)",
    x = "Grau",
    y = "Frequência"
  ) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_line(color = "gray85"),
    panel.grid.minor = element_line(color = "gray92")
  )

# 3b. Caminhos mínimos (amostragem para eficiência de memória)
paths <- distances(g, v = V(g)[1:100], to = V(g))
hist(
  paths,
  breaks = 50,
  main = "Distribuição de Caminhos Mínimos",
  xlab = "Tamanho do Caminho",
  col = adjustcolor("darkorange", alpha.f = 0.9),
  border = "black"
)

# 3c. Coeficiente de Clusterização
trans_global <- transitivity(g, type = "global") # ~ 0.08
trans_local <- mean(transitivity(g, type = "local"), na.rm = TRUE)
print(paste("Global:", round(trans_global, 4), "| Local (média):", round(trans_local, 4)))

# Algoritmos adequados e eficientes
cw <- cluster_walktrap(g)
cfg <- cluster_fast_greedy(g)
cle <- cluster_leading_eigen(g)
# ceb <- cluster_edge_betweenness(g) # Ignorado: Muito lento para N = 4941

# Comparação de Modularidade (qualidade das comunidades)
mod_cw <- modularity(cw)
mod_cfg <- modularity(cfg)
mod_cle <- modularity(cle)

print(data.frame(Algoritmo = c("Walktrap", "Fast Greedy", "Leading Eigenvector"),
                 Modularidade = c(mod_cw, mod_cfg, mod_cle)))


# Cálculo de betweenness
bet_nodes <- betweenness(g)
no_importante <- V(g)[which.max(bet_nodes)]
print(no_importante)


edge_bet <- edge_betweenness(g)
aresta_critica <- E(g)[which.max(edge_bet)]
print(aresta_critica)

diam <- diameter(g)
print(paste("Diâmetro da rede:", diam))
