# Questão 4
com_walktrap <- cluster_walktrap(g)
com_edge_betweenness <- cluster_edge_betweenness(g)
com_leading_eigen <- cluster_leading_eigen(g)
com_fast_greedy <- cluster_fast_greedy(g)

# Criando um Data Frame com os resultados para os 4 algoritmos
resultados <- data.frame(
  Algoritmo = c("Walktrap", "Edge Betweenness", "Leading Eigenvector", "Fast Greedy"),
  Modularidade = c(
    modularity(com_walktrap),
    modularity(com_edge_betweenness),
    modularity(com_leading_eigen),
    modularity(com_fast_greedy)
  ),
  Qtd_Comunidades = c(
    length(com_walktrap),
    length(com_edge_betweenness),
    length(com_leading_eigen),
    length(com_fast_greedy)
  )
)

# Ordenando do melhor (maior modularidade) para o pior
resultados_ordenados <- resultados[order(-resultados$Modularidade), ]

# Imprimindo a tabela no console para você ver o ranking
print("Comparação de Agrupamentos:")
print(resultados_ordenados)

# Pegamos o nome do algoritmo que ficou em primeiro lugar
melhor_algoritmo <- resultados_ordenados$Algoritmo[1]
print(melhor_algoritmo)

# Selecionamos o objeto de comunidade correspondente ao vencedor
if(melhor_algoritmo == "Fast Greedy") {
  melhor_comunidade <- com_fast_greedy
} else if(melhor_algoritmo == "Leading Eigenvector") {
  melhor_comunidade <- com_leading_eigen
} else if(melhor_algoritmo == "Walktrap") {
  melhor_comunidade <- com_walktrap
} else {
  melhor_comunidade <- com_edge_betweenness
}

# Plotando a rede com as fronteiras do melhor agrupamento
plot(melhor_comunidade, g, 
     main = paste("Melhor Agrupamento:", melhor_algoritmo),
     vertex.size = 15, 
     vertex.label.cex = 0.8,
     edge.color = "gray80")