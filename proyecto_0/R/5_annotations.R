
library(readxl)
library(openxlsx)


annotations <- read_excel(
  "proyecto_0/Data/Annotations/Gene_description_con_Modulos.xlsx"
)


colnames(annotations)


annotations <- annotations[, c("Gene_ID", "Gene Description")]


head(purpleSummary)

purpleAnnotated <- merge(
  purpleSummary,
  annotations,
  by.x = "Gene",
  by.y = "Gene_ID",
  all.x = TRUE
)

head(purpleSummary, 10)

#####Merge información kME y GS con anotaciones de genes###

# Crear tabla de métricas WGCNA
gene_WGCNA_metrics <- data.frame(
  Gene = colnames(datExpr),
  GS.K1 = GS.K1$GS.K1,
  kME = NA_real_
)

# Obtener el kME correspondiente al módulo de cada gen
for (i in seq_len(nrow(gene_WGCNA_metrics))) {

  module <- dynamicColors[i]

  kME_column <- paste0("kME", module)

  gene_WGCNA_metrics$kME[i] <- kME[i, kME_column]
}

# Valores absolutos
gene_WGCNA_metrics$abs_GS <- abs(
  gene_WGCNA_metrics$GS.K1
)

gene_WGCNA_metrics$abs_kME <- abs(
  gene_WGCNA_metrics$kME
)

# Unir con las anotaciones originales
annotations_WGCNA <- merge(
  annotations,
  gene_WGCNA_metrics,
  by.x = "Gene_ID",
  by.y = "Gene",
  all.x = TRUE
)

# Guardar como Excel
write.xlsx(
  annotations_WGCNA,
  "proyecto_0/Data/Annotations/Gene_kME_GS.xlsx",
  overwrite = TRUE
)

