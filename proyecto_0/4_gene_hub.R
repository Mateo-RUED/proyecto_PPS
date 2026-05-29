

kME <- signedKME(datExpr, MEs)

# 👉 Qué hace:
# Calcula la correlación entre cada gen y cada eigengene de módulo.
#
# Matemáticamente:
#
# kME = cor(gen, ModuleEigengene)
#
# Cuanto más alto sea el kME de un gen para un módulo,
# más representativo y central es dentro de ese módulo.
#
# Resultado:
# Una matriz:
#
#            kMEblue   kMEpurple   kMEgreen ...
# bgh00001     0.12      0.94        0.05
# bgh00002     0.83      0.10        0.03
# ...

purple_kME <- kME[dynamicColors == "purple", ]

# 👉 Qué hace:
# Conserva únicamente los genes que fueron asignados
# al módulo purple durante la detección de módulos.
#
# Resultado:
# Una tabla con los genes purple y sus kME
# respecto a TODOS los módulos.

purple_kME <- purple_kME[
  order(-purple_kME$kMEpurple),
]

# 👉 Qué hace:
# Ordena los genes desde el más conectado
# al menos conectado dentro del módulo purple.
#
# Los primeros genes serán los candidatos
# a hub genes del módulo.


head(purple_kME, 10)

# 👉 Qué hace:
# Muestra los 10 genes con mayor kMEpurple.
#
# Estos son los candidatos iniciales a hub genes.


############################################################
# Ver distribución de centralidad del módulo
############################################################

hist(purple_kME$kMEpurple)

# 👉 Qué hace:
# Muestra cómo se distribuyen los valores de kME.
#
# Permite ver:
# - Si existen unos pocos hubs muy fuertes.
# - O si todos los genes tienen conectividades similares.

count(purple_kME$kMEpurple > 0.9)

# 👉 Qué hace:
# Cuenta cuántos genes tienen kME superior a 0.9.
#
# Estos suelen considerarse hubs muy fuertes.


purpleHubs <- data.frame(
  Gene = rownames(purple_kME),
  kME = purple_kME$kMEpurple
)

# 👉 Qué hace:
# Genera una tabla simple:
#
# Gene        kME
# bgh06162    0.96
# bgh03838    0.95
# ...


head(purpleHubs, 20)

# 👉 Qué hace:
# Muestra los 20 genes más centrales del módulo purple.
#
# Estos son los candidatos más interesantes para:
# - biomarcadores
# - efectores
# - genes de virulencia
# - análisis funcional posterior

GS.K1 <- as.data.frame(
  cor(datExpr, traitData$K1, use = "p")
)

colnames(GS.K1) <- "GS.K1"

GS.purple <- GS.K1[dynamicColors == "purple", , drop = FALSE]

purpleSummary <- data.frame(
  Gene = rownames(purple_kME),
  kME = purple_kME$kMEpurple,
  GS = GS.purple$GS.K1
)

purpleSummary[
  order(-abs(purpleSummary$GS)),
] |> head(20)

purpleSummary$Score <- abs(purpleSummary$kME) *
                       abs(purpleSummary$GS)

purpleSummary <- purpleSummary[
  order(-purpleSummary$Score),
]

head(purpleSummary,20)

png(filename = "proyecto_0/imagenes/purple_kME_GS.png", width = 1600, height = 900, res = 150)
plot(
  abs(purpleSummary$GS),
  abs(purpleSummary$kME),
  xlab = "Gene Significance (K1)",
  ylab = "Module Membership (purple)",
  pch = 16
)
dev.off()


top20 <- head(purpleSummary, 20)

top20

write.table(
  top20,
  "proyecto_0/tabla_conteo/Top20_Purple_Hubs.txt",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

nombre_genes <- top20$Gene

nombre_genes




##Se identificó un módulo purple altamente asociado con K1 (r≈0.91).
## Dentro de este módulo, varios genes presentaron elevada membresía modular (kME)
## y alta significancia para K1 (GS), destacándose bgh06162, bgh03249 y bgh00192 como candidatos prioritarios.

