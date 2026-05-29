samples <- rownames(datExpr)

traitData <- data.frame(
  sample = samples,
  
  B12 = ifelse(grepl("^B12", samples), 1, 0),
  
  K1 = ifelse(grepl("_K1_", samples), 1, 0),
  
  time = as.numeric(sub(".*_(\\d+)hpi.*", "\\1", samples))
)

traitData$Interaction <- traitData$B12 * traitData$K1

head(traitData, 48)


moduleTraitCor <- cor(
  MEs,
  traitData[, c("B12", "K1", "time", "Interaction")],
  use = "p"
)

head (moduleTraitCor, 10)

png(filename = "proyecto_1/imagenes/correlacion_modulos_rasgos.png", width = 1600, height = 900, res = 150)
labeledHeatmap(
  Matrix = moduleTraitCor,
  xLabels = c("B12", "K1", "time", "Interaction"),
  yLabels = names(MEs),
  ySymbols = names(MEs),
  colorLabels = FALSE,
  colors = blueWhiteRed(50),
  textMatrix = signif(moduleTraitCor, 2),
  setStdMargins = FALSE,
  cex.text = 0.7,
  zlim = c(-1,1)
)
dev.off()

moduleTraitPvalue <- corPvalueStudent(
  moduleTraitCor,
  nSamples = nrow(datExpr)
)

head (moduleTraitPvalue, 10)

purpleGenes <- colnames(datExpr)[dynamicColors == "purple"]

head(purpleGenes, 46)

table(dynamicColors)

