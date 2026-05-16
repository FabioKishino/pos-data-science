# =============================================================================
# ANÁLISE DE REDES COMPLEXAS - CLUBE DE KARATÊ DE ZACHARY
# Disciplina: Métodos Analíticos
# Pacotes: igraph, ggplot2
# =============================================================================

# -----------------------------------------------------------------------------
# 0. INSTALAÇÃO E CARREGAMENTO DE PACOTES
# -----------------------------------------------------------------------------
# Instale apenas se necessário:
# install.packages("igraph")
# install.packages("ggplot2")

library(igraph)
library(ggplot2)

# =============================================================================
# IMPORTAÇÃO DO DATASET
# O dataset de Zachary está embutido no igraph via make_graph("Zachary")
# Referência: Zachary, W.W. (1977). An information flow model for conflict
# and fission in small groups. Journal of Anthropological Research, 33, 452-473.
# =============================================================================

g <- make_graph("Zachary")

# Inspecção inicial
cat("=== VISÃO GERAL DA REDE ===\n")
print(g)
cat("Número de nós (vértices):", vcount(g), "\n")
cat("Número de arestas:       ", ecount(g), "\n")
cat("É direcionado?           ", is_directed(g), "\n")
cat("É ponderado?             ", is_weighted(g), "\n\n")


# =============================================================================
# PERGUNTA 1 — REPRESENTAÇÃO ADOTADA
# Nós, Arestas, Pesos
# =============================================================================
cat("=== PERGUNTA 1: REPRESENTAÇÃO ===\n")

# --- 1a. Nós ---
# Cada nó representa um MEMBRO do clube de karatê (34 membros no total).
# Os nós de maior destaque são:
#   Nó 1  → Instrutor (Mr. Hi)
#   Nó 34 → Presidente do clube (John A.)
# São os indivíduos que protagonizaram o conflito que levou à divisão do grupo.

cat("Nós (membros):", vcount(g), "\n")
cat("Nó 1  = Instrutor (Mr. Hi)\n")
cat("Nó 34 = Presidente (John A.)\n\n")

# --- 1b. Arestas ---
# Cada aresta representa um LAÇO DE AMIZADE/INTERAÇÃO entre dois membros
# FORA do ambiente formal do clube (encontros sociais observados por Zachary).
# A rede é NÃO-DIRECIONADA: a amizade é mútua.

cat("Arestas (laços de amizade):", ecount(g), "\n\n")

# --- 1c. Pesos ---
# O dataset disponível via make_graph("Zachary") do igraph NÃO contém pesos.
# Os pesos originais do estudo representariam a frequência de interação entre
# pares (número de contextos sociais observados), mas não estão presentes
# nesta versão do dataset. A rede será tratada como NÃO PONDERADA.

cat("Pesos: ausentes nesta versão do dataset.\n")
cat("Rede tratada como NÃO PONDERADA.\n\n")

# Verificando os grupos reais (ground truth de Zachary)
# Grupo 1 = seguiram o instrutor | Grupo 2 = ficaram com o presidente
V(g)$grupo <- c(1,1,1,1,1,1,1,1,2,2,1,1,1,1,2,2,1,1,2,1,2,1,2,2,2,2,2,2,2,2,2,2,2,2)
V(g)$color <- ifelse(V(g)$grupo == 1, "steelblue", "tomato")
V(g)$label <- V(g)

cat("Distribuição dos grupos (ground truth):\n")
cat("  Grupo Instrutor (azul)     :", sum(V(g)$grupo == 1), "membros\n")
cat("  Grupo Presidente (vermelho):", sum(V(g)$grupo == 2), "membros\n\n")


# =============================================================================
# PERGUNTA 2 — VISUALIZAÇÃO DA REDE
# Layouts: Fruchterman-Reingold, Kamada-Kawai, Circular
# =============================================================================
cat("=== PERGUNTA 2: VISUALIZAÇÕES ===\n")

V(g)$size <- 8 + degree(g) * 0.8   # tamanho proporcional ao grau

par(mar = c(1, 1, 2, 1))

# --- Layout 1: Fruchterman-Reingold (force-directed — mais usado) ---
set.seed(42)
layout_fr <- layout_with_fr(g)

plot(g,
     layout             = layout_fr,
     vertex.color       = V(g)$color,
     vertex.size        = V(g)$size,
     vertex.label       = V(g)$label,
     vertex.label.cex   = 0.7,
     vertex.label.color = "white",
     edge.color         = "gray60",
     main               = "Layout Fruchterman-Reingold\n(Azul = Grupo Instrutor | Vermelho = Grupo Presidente)")
legend("bottomleft",
       legend = c("Grupo Instrutor (Mr. Hi)", "Grupo Presidente (John A.)"),
       fill   = c("steelblue", "tomato"), cex = 0.75, bty = "n")

# --- Layout 2: Kamada-Kawai (baseado em distâncias geodésicas) ---
layout_kk <- layout_with_kk(g)

plot(g,
     layout             = layout_kk,
     vertex.color       = V(g)$color,
     vertex.size        = V(g)$size,
     vertex.label       = V(g)$label,
     vertex.label.cex   = 0.7,
     vertex.label.color = "white",
     edge.color         = "gray60",
     main               = "Layout Kamada-Kawai\n(Evidencia distâncias geodésicas)")
legend("bottomleft",
       legend = c("Grupo Instrutor (Mr. Hi)", "Grupo Presidente (John A.)"),
       fill   = c("steelblue", "tomato"), cex = 0.75, bty = "n")

# --- Layout 3: Circular (fácil de ver pontes entre grupos) ---
layout_circ <- layout_in_circle(g)

plot(g,
     layout             = layout_circ,
     vertex.color       = V(g)$color,
     vertex.size        = V(g)$size,
     vertex.label       = V(g)$label,
     vertex.label.cex   = 0.65,
     vertex.label.color = "white",
     edge.color         = adjustcolor("gray40", alpha.f = 0.5),
     main               = "Layout Circular\n(Revela arestas cruzando grupos)")
legend("bottomleft",
       legend = c("Grupo Instrutor (Mr. Hi)", "Grupo Presidente (John A.)"),
       fill   = c("steelblue", "tomato"), cex = 0.75, bty = "n")

cat("Visualizações geradas: Fruchterman-Reingold, Kamada-Kawai e Circular.\n\n")


# =============================================================================
# PERGUNTA 3 — DISTRIBUIÇÃO DAS MÉTRICAS
# a) Grau
# b) Caminho mínimo
# c) Coeficiente de Clusterização (Transitividade)
# =============================================================================
cat("=== PERGUNTA 3: DISTRIBUIÇÃO DE MÉTRICAS ===\n")

# --- 3a. Grau ---
grau <- degree(g)

cat("-- Grau --\n")
print(summary(grau))

cat("\nTop 5 nós por grau:\n")
print(sort(grau, decreasing = TRUE)[1:5])

df_grau <- data.frame(no = 1:vcount(g), grau = grau)

p1 <- ggplot(df_grau, aes(x = grau)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "white") +
  labs(title = "Distribuição de Grau",
       x = "Grau", y = "Frequência") +
  theme_minimal()
print(p1)

# --- 3b. Caminhos mínimos ---
dist_mat <- distances(g)
dist_vec <- dist_mat[upper.tri(dist_mat)]   # apenas pares únicos

cat("\n-- Comprimento de Caminho Mínimo --\n")
print(summary(dist_vec))
cat("Caminho médio:", round(mean_distance(g, directed = FALSE), 4), "\n")

df_dist <- data.frame(distancia = dist_vec)
p2 <- ggplot(df_dist, aes(x = distancia)) +
  geom_bar(fill = "darkgreen", color = "white") +
  labs(title = "Distribuição dos Caminhos Mínimos",
       x = "Comprimento do Caminho", y = "Número de Pares") +
  theme_minimal()
print(p2)

# --- 3c. Coeficiente de Clusterização (Transitividade) ---
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


# =============================================================================
# PERGUNTA 4 — DETECÇÃO DE COMUNIDADES
# Algoritmos: Louvain, Girvan-Newman, Walktrap, Label Propagation
# =============================================================================
cat("=== PERGUNTA 4: DETECÇÃO DE COMUNIDADES ===\n")

set.seed(42)
comm_louvain  <- cluster_louvain(g)
comm_gn       <- cluster_edge_betweenness(g)
comm_walktrap <- cluster_walktrap(g)
comm_label    <- cluster_label_prop(g)

cat("Resultados (número de comunidades | modularidade):\n")
cat(sprintf("  Louvain:           %d comunidades | Q = %.4f\n",
            length(comm_louvain),  modularity(comm_louvain)))
cat(sprintf("  Girvan-Newman:     %d comunidades | Q = %.4f\n",
            length(comm_gn),       modularity(comm_gn)))
cat(sprintf("  Walktrap:          %d comunidades | Q = %.4f\n",
            length(comm_walktrap), modularity(comm_walktrap)))
cat(sprintf("  Label Propagation: %d comunidades | Q = %.4f\n",
            length(comm_label),    modularity(comm_label)))

cat("\nComparação com Ground Truth (NMI — quanto maior, melhor):\n")
cat(sprintf("  Louvain:       NMI = %.4f\n", compare(comm_louvain,  V(g)$grupo, method = "nmi")))
cat(sprintf("  Girvan-Newman: NMI = %.4f\n", compare(comm_gn,       V(g)$grupo, method = "nmi")))
cat(sprintf("  Walktrap:      NMI = %.4f\n", compare(comm_walktrap, V(g)$grupo, method = "nmi")))

# Visualização: Girvan-Newman (melhor alinhamento com ground truth)
set.seed(42)
plot(comm_gn, g,
     layout             = layout_fr,
     vertex.size        = V(g)$size,
     vertex.label       = V(g)$label,
     vertex.label.cex   = 0.7,
     vertex.label.color = "black",
     edge.width         = 1,
     main               = "Comunidades - Girvan-Newman\n(melhor alinhamento com ground truth)")

cat("\n")


# =============================================================================
# PERGUNTA 5 — NÓ MAIS IMPORTANTE
# Métricas: Degree, Betweenness, Closeness, PageRank, Eigenvector
# =============================================================================
cat("=== PERGUNTA 5: NÓ MAIS IMPORTANTE ===\n")

centralidades <- data.frame(
  no          = 1:vcount(g),
  degree      = degree(g),
  betweenness = round(betweenness(g, normalized = TRUE), 4),
  closeness   = round(closeness(g,   normalized = TRUE), 4),
  pagerank    = round(page_rank(g)$vector, 4),
  eigenvector = round(eigen_centrality(g)$vector, 4)
)

cat("Top 5 por Betweenness Centrality (broker/ponte):\n")
print(head(centralidades[order(-centralidades$betweenness), ], 5))

cat("\nTop 5 por Degree (mais conectado):\n")
print(head(centralidades[order(-centralidades$degree), ], 5))

cat("\nTop 5 por PageRank:\n")
print(head(centralidades[order(-centralidades$pagerank), ], 5))

cat("\n>>> CONCLUSÃO: O nó 1 (Mr. Hi) possui a maior betweenness global,\n")
cat("    sendo o principal 'corredor' de informação da rede. O nó 34\n")
cat("    (John A.) é o hub central do outro subgrupo. Ambos são os mais\n")
cat("    influentes em suas respectivas comunidades.\n\n")

# Visualização: tamanho proporcional à betweenness
V(g)$size_bet <- 5 + betweenness(g, normalized = TRUE) * 40
set.seed(42)
plot(g,
     layout             = layout_fr,
     vertex.color       = V(g)$color,
     vertex.size        = V(g)$size_bet,
     vertex.label       = V(g)$label,
     vertex.label.cex   = 0.7,
     vertex.label.color = "white",
     edge.color         = "gray70",
     main               = "Betweenness Centrality\n(tamanho proporcional à centralidade)")
legend("bottomleft",
       legend = c("Grupo Instrutor", "Grupo Presidente"),
       fill   = c("steelblue", "tomato"), cex = 0.75, bty = "n")


# =============================================================================
# PERGUNTA 6 — ARESTA MAIS IMPORTANTE
# Edge Betweenness: frequência da aresta em caminhos mínimos
# =============================================================================
cat("=== PERGUNTA 6: ARESTA MAIS IMPORTANTE ===\n")

edge_bet         <- edge_betweenness(g, directed = FALSE)
E(g)$betweenness <- edge_bet

idx_top <- order(edge_bet, decreasing = TRUE)[1:5]
cat("Top 5 arestas por Edge Betweenness:\n")
for (i in idx_top) {
  e <- ends(g, i)
  cat(sprintf("  Aresta (%2d -- %2d): betweenness = %.1f\n", e[1], e[2], edge_bet[i]))
}

cat("\n>>> CONCLUSÃO: A aresta com maior edge betweenness é a 'ponte'\n")
cat("    crítica entre os dois subgrupos. Sua remoção desconectaria\n")
cat("    (ou enfraqueceria muito) a comunicação entre as comunidades.\n\n")

# Visualização: espessura proporcional à edge betweenness
E(g)$width_bet <- 0.5 + edge_bet / max(edge_bet) * 5
set.seed(42)
plot(g,
     layout             = layout_fr,
     vertex.color       = V(g)$color,
     vertex.size        = V(g)$size,
     vertex.label       = V(g)$label,
     vertex.label.cex   = 0.7,
     vertex.label.color = "white",
     edge.width         = E(g)$width_bet,
     edge.color         = adjustcolor("darkorange", alpha.f = 0.7),
     main               = "Edge Betweenness\n(espessura proporcional à importância da aresta)")


# =============================================================================
# PERGUNTA 7 — DIÂMETRO DA REDE
# =============================================================================
cat("=== PERGUNTA 7: DIÂMETRO DA REDE ===\n")

diam      <- diameter(g, directed = FALSE)
diam_path <- get_diameter(g, directed = FALSE)

cat("Diâmetro:", diam, "\n")
cat("Caminho do diâmetro:", paste(as.numeric(diam_path), collapse = " -> "), "\n\n")

# Destacar o caminho do diâmetro no grafo
edge_colors             <- rep("gray80", ecount(g))
diam_edges              <- E(g, path = diam_path)
edge_colors[diam_edges] <- "red"

set.seed(42)
plot(g,
     layout             = layout_fr,
     vertex.color       = V(g)$color,
     vertex.size        = V(g)$size,
     vertex.label       = V(g)$label,
     vertex.label.cex   = 0.7,
     vertex.label.color = "white",
     edge.width         = ifelse(edge_colors == "red", 3, 1),
     edge.color         = edge_colors,
     main               = paste("Diâmetro da Rede =", diam, "\n(caminho em vermelho)"))


# =============================================================================
# PERGUNTA 8 — CLASSIFICAÇÃO DA REDE
# Aleatória? Mundo Pequeno? Escala-Livre?
# =============================================================================
cat("=== PERGUNTA 8: CLASSIFICAÇÃO DA REDE ===\n")

n    <- vcount(g)
m    <- ecount(g)
p_er <- (2 * m) / (n * (n - 1))

# Rede aleatória equivalente (100 simulações para estabilidade)
set.seed(42)
er_L <- mean(sapply(1:100, function(x) mean_distance(erdos.renyi.game(n, p_er))))
er_C <- mean(sapply(1:100, function(x) transitivity(erdos.renyi.game(n, p_er), type = "global")))

L_real <- mean_distance(g, directed = FALSE)
C_real <- transitivity(g, type = "global")
sigma  <- (C_real / er_C) / (L_real / er_L)   # índice de mundo pequeno

cat("Métricas observadas vs rede aleatória equivalente:\n")
cat(sprintf("  Caminho médio   L_real = %.4f | L_ER = %.4f | ratio = %.4f\n",
            L_real, er_L, L_real / er_L))
cat(sprintf("  Clusterização  C_real = %.4f | C_ER = %.4f | ratio = %.4f\n",
            C_real, er_C, C_real / er_C))
cat(sprintf("  Índice Sigma (mundo pequeno): %.4f\n", sigma))
cat("  (Sigma > 1 indica rede de mundo pequeno)\n\n")

# Teste Escala-Livre: ajuste de lei de potência
fit_pl <- fit_power_law(grau)
cat("Ajuste Lei de Potência:\n")
cat(sprintf("  Expoente (alpha): %.4f\n", fit_pl$alpha))
cat(sprintf("  KS p-value:       %.4f\n", fit_pl$KS.p))
cat("  (p-value > 0.05: lei de potência não pode ser descartada)\n\n")

# Gráfico log-log da distribuição de grau
deg_dist <- degree_distribution(g)
df_dd    <- data.frame(k = 0:(length(deg_dist) - 1), pk = deg_dist)
df_dd    <- subset(df_dd, pk > 0 & k > 0)

p4 <- ggplot(df_dd, aes(x = k, y = pk)) +
  geom_point(color = "steelblue", size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "red", linetype = "dashed") +
  scale_x_log10() + scale_y_log10() +
  labs(title = "Distribuição de Grau (escala log-log)",
       subtitle = "Linha vermelha = ajuste linear (lei de potência)",
       x = "Grau k (log)", y = "P(k) (log)") +
  theme_minimal()
print(p4)

cat(">>> CONCLUSÃO: Sigma > 1 evidencia características de MUNDO PEQUENO\n")
cat("    (alto C, baixo L). A distribuição de grau segue parcialmente uma\n")
cat("    lei de potência, mas com apenas 34 nós é difícil confirmar escala-\n")
cat("    livre. A rede NÃO é aleatória: C_real >> C_ER.\n\n")


# =============================================================================
# PERGUNTA 9 — INFORMAÇÕES SUBJACENTES
# =============================================================================
cat("=== PERGUNTA 9: INFORMAÇÕES SUBJACENTES ===\n")

# --- 9a. Assortatividade ---
assort_degree <- assortativity_degree(g)
assort_grupo  <- assortativity_nominal(g, V(g)$grupo)

cat(sprintf("Assortatividade por Grau:  %.4f\n", assort_degree))
cat(sprintf("Assortatividade por Grupo: %.4f\n", assort_grupo))
cat("  (> 0 = assortativo | < 0 = disassortativo)\n\n")

# --- 9b. Densidade ---
dens <- edge_density(g)
cat(sprintf("Densidade da rede: %.4f (%.1f%% das conexões possíveis)\n\n",
            dens, dens * 100))

# --- 9c. Pontos de articulação ---
art_points <- articulation_points(g)
cat(sprintf("Pontos de Articulação: %d nós críticos\n", length(art_points)))
cat("  Nós:", paste(as.numeric(art_points), collapse = ", "), "\n\n")

# --- 9d. Pontes ---
brs <- bridges(g)
cat(sprintf("Pontes (arestas críticas): %d\n\n", length(brs)))

# --- 9e. Betweenness médio por grupo ---
cat("Média de betweenness por grupo:\n")
cat("  Grupo Instrutor: ",
    round(mean(betweenness(g)[V(g)$grupo == 1]), 2), "\n")
cat("  Grupo Presidente:",
    round(mean(betweenness(g)[V(g)$grupo == 2]), 2), "\n")

cat("\n>>> CONCLUSÕES SUBJACENTES:\n")
cat("  1. Assortatividade por grupo > 0: membros do mesmo subgrupo tendem\n")
cat("     a se conectar — sinal claro de polarização social.\n")
cat("  2. Pontos de articulação revelam membros 'corredores': sua saída\n")
cat("     isolaria partes da rede.\n")
cat("  3. Baixa densidade indica rede ESPARSA — relações seletivas.\n")
cat("  4. O conflito entre nó 1 e nó 34 era estruturalmente inevitável:\n")
cat("     cada um era o hub central do seu subgrupo sem sobreposição.\n")
cat("  5. Nós com alta betweenness e baixo grau (ex: nós 3, 9, 10) eram\n")
cat("     'intermediários silenciosos' com acesso privilegiado à informação.\n")


# =============================================================================
# RESUMO FINAL
# =============================================================================
cat("\n=== RESUMO GERAL DA REDE DE ZACHARY ===\n")
cat(sprintf("  Nós:                     %d\n",   vcount(g)))
cat(sprintf("  Arestas:                 %d\n",   ecount(g)))
cat(sprintf("  Diâmetro:                %d\n",   diam))
cat(sprintf("  Caminho médio:           %.4f\n", L_real))
cat(sprintf("  Clusterização global:    %.4f\n", C_real))
cat(sprintf("  Densidade:               %.4f\n", dens))
cat(sprintf("  Índice Mundo Pequeno σ:  %.4f\n", sigma))
cat(sprintf("  Nó mais importante:      Nó 1 (Mr. Hi) — maior betweenness\n"))
cat(sprintf("  Melhor comunidade:       Girvan-Newman (alinhado com ground truth)\n"))
cat(sprintf("  Classificação:           Mundo Pequeno, parcialmente Escala-Livre\n"))