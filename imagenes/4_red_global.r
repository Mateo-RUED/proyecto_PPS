threshold <- 0.45

TOM_filtered <- TOM

TOM_filtered[TOM_filtered < threshold] <- 0



library(igraph)

g_all <- graph_from_adjacency_matrix(
  TOM_filtered,
  mode = "undirected",
  weighted = TRUE,
  diag = FALSE
)


V(g_all)$color <- dynamicColors



g_all <- delete_vertices(
  g_all,
  degree(g_all) == 0
)



plot(
  g_all,
  vertex.size = 3,
  vertex.label = NA,
  edge.width = 0.3,
  layout = layout_with_fr
)