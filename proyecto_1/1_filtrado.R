library(DESeq2)

data <- read.table(
"proyecto_1/tabla_conteo/GSE43163_CompleteCountTable_Bgh.txt", # nolint
header=TRUE,
row.names=1,
sep="\t"
)


colData <- data.frame(
  row.names = colnames(data)
)

"👉 Qué hace:

crea una tabla de “información de muestras”
por ahora está vacía (solo nombres)

👉 ¿Por qué existe esto?
Porque DESeq2 normalmente usa info experimental (condición, tiempo, etc.), pero nosotros ahora solo queremos normalizar, # nolint
 así que usamos lo mínimo.
"

keep <- rowSums(data) >= 100
data_filtered <- data[keep, ]

"👉 Qué hace    
    Filtra genes con baja expresión
    Mantiene genes con al menos 100 lecturas en total por fila
    Esto mejora la calidad del análisis al eliminar ruido
    "


dds <- DESeqDataSetFromMatrix(
  countData = data_filtered,
  colData = colData,
  design = ~ 1
)

"👉 Qué hace:

Convierte tu matriz en un objeto especial que contiene:

conteos crudos
info de muestras
estructura para análisis

👉 design = ~1 significa:

👉 “no estoy modelando condiciones, solo quiero normalizar”

"

keep <- rowSums(data) >= 100
data_filtered <- data[keep, ]

"👉 Qué hace    
    Filtra genes con baja expresión
    Mantiene genes con al menos 100 lecturas en total por fila
    Esto mejora la calidad del análisis al eliminar ruido
    "


dds <- estimateSizeFactors(dds)
"👉 Qué hace    :
    Estima los factores de tamaño para normalizar los conteos
    Esto ajusta los conteos para tener en cuenta las diferencias en profundidad de secuenciación # nolint: line_length_linter.
    Es un paso crucial para comparar muestras de manera justa
    primero se debe normalizar a partir de las musgtras d eesta manera no cometemos el error # nolint
    de aplizar VST antes ya que pueden haber muestras que secuenciaron mas lecturas # nolint
    que otras y eso nos dan errores en la varianza estabilizada
    "

vsd <- vst(dds, blind = TRUE)

"👉 Qué hace    :
    Aplica la transformación de varianza estabilizada (VST)
    Esto hace que los datos sean más comparables entre genes y muestras
    Es útil para visualización y análisis exploratorio
    de esta manera no cometemos el error de aplicar VST antes ya que pueden haber muestras que secuenciaron mas lecturas # nolint
    que otras y eso nos dan errores en la varianza estabilizada.

    De esta forma todos los genes tienen una varianza casi constante, lo que facilita la comparación entre ellos # nolint
    y mejora la calidad de análisis posteriores (clustering, PCA, etc.)
    "

datExpr <- assay(vsd)

datExpr <- t(datExpr)


"👉 Qué hace    :
    Transpone la matriz para que las muestras sean filas y los genes columnas
    Guarda la matriz normalizada en un nuevo archivo de texto"


write.table(
  datExpr,
  "proyecto_1/tabla_conteo/GSE43163_CompleteCountTable_Bgh_normalized.txt",
  sep="\t",
  quote=FALSE
)
