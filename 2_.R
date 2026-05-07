dim(datExpr)


corMatrix <- cor(datExpr, method = "pearson")


"👉 Qué hace    :
    Calcula la matriz de correlación entre muestras usando el método de Pearson
    Esto te da una idea de qué tan similares son las muestras entre sí
    Es útil para detectar agrupamientos o patrones en los datos
    "

library(WGCNA)

gsg <- goodSamplesGenes(datExpr, verbose = 3)