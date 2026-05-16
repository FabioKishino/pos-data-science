setwd("~/Documents/Dev/pos-data-science/metodos-analiticos")
library(igraph)
library(ggplot2)
library(ggmap) # Nota: Uso limitado sem coordenadas geográficas

# Carregamento tratando IDs como caracteres para evitar o erro de índice 0
edges <- read.table("router_inet/router_INET.txt", header = FALSE, colClasses = "character")
g <- graph_from_edgelist(as.matrix(edges), directed = FALSE)

# Plotar uma amostra ou usar layout otimizado para evitar travamentos
# Sugestão: Amostragem de 1000 nós para visualização rápida
g_sub <- induced_subgraph(g, V(g)[1:1000])
plot(g_sub, layout = layout_with_fr, vertex.size = 3, vertex.label = NA, edge.arrow.size = 0.2)

# 3a. Grau
deg <- degree(g)
df_deg <- as.data.frame(table(deg))

ggplot(df_deg, aes(x = as.numeric(deg), y = Freq)) + 
  geom_point(color = "steelblue", size = 2) +
  scale_x_log10() + 
  scale_y_log10() + 
  theme_minimal() +
  labs(
    title = "Distribuição de Grau (Log)", 
    x = "Grau", 
    y = "Frequência"
  )


# 3b. Caminhos Mínimos (Amostra para velocidade)
# Calculando a tabela de distâncias (frequência de cada distância)
dist_data <- distance_table(g, directed = FALSE)
df_dist <- data.frame(Distancia = 1:length(dist_data$res), Freq = dist_data$res)

ggplot(df_dist, aes(x = Distancia, y = Freq)) +
  geom_col(fill = "darkorange", color = "black", alpha = 0.9) +
  theme_minimal() +
  labs(title = "Distribuição de Caminhos Mínimos", x = "Distância (Hops)", y = "Contagem")

# --- Ajuste para Questão 3b: Caminhos Mínimos por Amostragem ---

# 1. Definir uma semente para reprodutibilidade e tamanho da amostra
set.seed(123)
n_amostra <- 500 
nos_amostra <- sample(V(g), n_amostra)

# 2. Calcular distâncias apenas a partir desses nós (muito mais rápido)
# A função distances retorna uma matriz; transformamos em vetor
dist_matriz <- distances(g, v = nos_amostra, to = V(g))
dist_vetor <- as.vector(dist_matriz)

# 3. Limpar dados: remover infinitos (nós desconexos) e distância 0 (nó para ele mesmo)
dist_vetor <- dist_vetor[is.finite(dist_vetor) & dist_vetor > 0]

# 4. Criar dataframe para o ggplot
df_dist <- as.data.frame(table(dist_vetor))
colnames(df_dist) <- c("Distancia", "Freq")
df_dist$Distancia <- as.numeric(as.character(df_dist$Distancia))

# 5. Plot com a estilização solicitada
ggplot(df_dist, aes(x = Distancia, y = Freq)) +
  geom_col(fill = "darkorange", color = "black", alpha = 0.9) +
  theme_minimal() +
  labs(title = "Distribuição de Caminhos Mínimos (Amostragem n=500)", 
       x = "Distância (Hops/Saltos)", 
       y = "Frequência")

# 3c. Clusterização
# Transitividade global
trans_global <- transitivity(g, type = "global")
print(paste("Coeficiente de Clusterização Global:", round(trans_global, 4)))
# Global: ~0.016 (valor baixo típico de infraestruturas de rede de longa distância)

trans_local  <- transitivity(g, type = "local")
cat("Transitividade Local (média): ", round(mean(trans_local, na.rm = TRUE), 4), "\n")

# --- Ajuste para Questão 4: Comunidades em Larga Escala ---

# O cluster_louvain é ordens de grandeza mais rápido para 192k nós
# Ele detecta comunidades baseando-se na otimização local da modularidade
c_lv <- cluster_louvain(g)

# Se você precisar de algo ainda mais moderno e robusto:
# c_leiden <- cluster_leiden(g, objective_function = "modularity")

# Resultado da Modularidade (Métrica de qualidade: 0 a 1)
mod_score <- modularity(c_lv)

cat("Comunidades detectadas (Louvain):", length(c_lv), "\n")
cat("Modularidade alcançada:", mod_score, "\n")

# Comparação rápida: Por que ignoramos os outros?
# Edge Betweenness: Levaria semanas.
# Walktrap: Travaria por falta de RAM.
# Fast Greedy: Muito lento para o ganho de modularidade que oferece aqui.


top_node <- which.max(degree(g))
top_node

# Para ver o ID do roteador (o nome)
nome_do_hub <- names(which.max(degree(g)))
nome_do_hub
# Resultado esperado: "1736"

# Para ver QUANTAS conexões ele tem (o grau)
valor_do_grau <- max(degree(g))
valor_do_grau
# Justificativa: O nó com maior grau é o hub central da topologia.


# 1. Definir o número de hubs para o "núcleo" (ex: os 100 maiores)
X <- 1000
top_hubs_ids <- V(g)[order(degree(g), decreasing = TRUE)[1:X]]

# 2. Criar um subgrafo contendo apenas esses hubs e as conexões entre eles
g_hubs <- induced_subgraph(g, top_hubs_ids)

# 3. Calcular o Edge Betweenness apenas para este subgrafo (rápido)
eb_hubs <- edge_betweenness(g_hubs)

# 4. Identificar a aresta com o maior valor
idx_critica <- which.max(eb_hubs)
aresta_critica <- ends(g_hubs, idx_critica)

# 5. Resultado: IDs dos dois roteadores que formam a aresta
cat("Aresta Crítica conecta os hubs:", aresta_critica[1], "<->", aresta_critica[2], "\n")
cat("Valor de Intermediação (no núcleo):", eb_hubs[idx_critica])

d <- diameter(g, directed = FALSE)
d
# Representa o número máximo de saltos entre quaisquer dois roteadores na amostra.
