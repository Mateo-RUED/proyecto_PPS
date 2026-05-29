kME <- signedKME(datExpr, MEs)

purple_kME <- kME[dynamicColors == "purple", ]

topHubGenes <- purple_kME[
  order(-abs(purple_kME$kMEpurple)),
]

head(topHubGenes, 10)

hist(topHubGenes$kME)



