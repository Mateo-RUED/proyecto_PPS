install.packages("igraph")

library(igraph)

module <- "red"

inModule <- dynamicColors == module

modGenes <- colnames(datExpr)[inModule]

modTOM <- TOM[inModule, inModule]


threshold <- 0.15

modTOM[modTOM < threshold] <- 0


g <- graph_from_adjacency_matrix(
  modTOM,
  mode = "undirected",
  weighted = TRUE,
  diag = FALSE
)


png(filename = "imagenes/plot_red.png", width = 1200, height = 800, res = 150)
plot(
  g,
  vertex.size = 5,
  vertex.label = NA,
  layout = layout_with_fr
)
dev.off()