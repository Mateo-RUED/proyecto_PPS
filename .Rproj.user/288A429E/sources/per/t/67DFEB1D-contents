library(WGCNA)

gsg <- goodSamplesGenes(datExpr, verbose = 3)

gsg$allOK

"   👉 Qué hace :
    Verifica que tus datos estén en buen estado para el análisis WGCNA
    Revisa muestras y genes con demasiados valores faltantes o baja varianza
    Si gsg$allOK es TRUE, tus datos están listos para el siguiente paso"

powers <- c(1:10, seq(12,20,2))

"👉 Qué hace:
    Define un rango de potencias para evaluar la escala de la red
    WGCNA busca una potencia que haga que la red siga una distribución de grado de ley
    Esto ayuda a identificar módulos de genes que están altamente conectados
    La función pickSoftThreshold te ayudará a elegir la mejor potencia basada en criterios como el índice de escala libre y la media de conectividad
    "

sft <- pickSoftThreshold(
  datExpr,
  powerVector = powers,
  networkType = "signed"
)

"👉 Qué hace:
    Evalúa diferentes potencias para construir la red
    Devuelve métricas como el índice de escala libre y la media de conectividad para cada potencia
    Puedes usar estas métricas para elegir la potencia que mejor se ajuste a tus datos
    En general, buscas una potencia donde el índice de escala libre sea alto (cercano a 0.8) y la media de conectividad no sea demasiado baja
    "

softPower <- 4

adjacency_matrix <- adjacency(
  datExpr,
  power = softPower,
  type = "signed"
)


"   👉 Qué hace:
    Construye la matriz de adyacencia usando la potencia elegida
    Esto convierte las correlaciones entre genes en una medida de conexión
    En una red 'signed', solo las correlaciones positivas contribuyen a la conexión, lo que puede ayudar a identificar módulos más coherentes
    La matriz de adyacencia es la base para calcular la similitud topológica y construir la red de coexpresión
    "

TOM <- TOMsimilarity(
  adjacency_matrix,
  TOMType = "signed"
)

"👉 Qué hace:
    Calcula la similitud topológica entre genes basada en la matriz de adyacencia
    La similitud topológica mide cómo de similares son los patrones de conexión entre genes
    En una red 'signed', se enfoca en conexiones positivas, lo que puede mejorar la detección de módulos funcionales
    La matriz TOM es más robusta que la matriz de adyacencia para identificar módulos de genes altamente conectados
    La similitud topológica es crucial para la identificación de módulos, ya que agrupa genes que tienen patrones de conexión similares"

dissTOM <- 1 - TOM

"👉 Qué hace:
    Convierte la similitud topológica en una medida de disimilitud
    Esto es necesario para realizar el clustering jerárquico, que agrupa genes basándose en su disimilitud
    Al restar la similitud de 1, obtenemos una medida donde valores cercanos a 0 indican genes muy similares y valores cercanos a 1 indican genes muy diferentes
    La disimilitud TOM se utiliza para construir el árbol de genes y posteriormente identificar módulos de genes altamente conectados
    "

geneTree <- hclust(
  as.dist(dissTOM),
  method = "average"
)

"👉 Qué hace:
    Realiza un clustering jerárquico basado en la disimilitud TOM
    Agrupa genes similares en clústeres que representan módulos funcionales
    El método 'average'calcula la distancia promedio entre genes en diferentes clústeres
    "

plot(
  geneTree,
  main = "Gene clustering on TOM-based dissimilarity",
  sub = "",
  xlab = "",
  cex = 0.3
)


dynamicMods <- cutreeDynamic(
  dendro = geneTree,
  distM = dissTOM,
  deepSplit = 2,
  pamRespectsDendro = FALSE,
  minClusterSize = 30
)

"👉 Qué hace:
    Corta el árbol de genes para identificar módulos de genes altamente conectados
    Utiliza la disimilitud TOM para guiar el corte, lo que mejora la detección de módulos funcionales
    El parámetro deepSplit controla la sensibilidad del corte (valores más altos pueden identificar más módulos)
    El parámetro minClusterSize establece el tamaño mínimo de los módulos, lo que ayuda a evitar la identificación de módulos muy pequeños y poco significativos
    La función cutreeDynamic es una forma flexible y robusta de identificar módulos en redes de coexpresión
    "

dynamicColors <- labels2colors(dynamicMods)

"👉 Qué hace:
    Asigna colores a cada módulo identificado para facilitar la visualización
    Cada módulo de genes se representa con un color diferente, lo que ayuda a distinguirlos en el dendrograma y en análisis posteriores
    La función labels2colors convierte los números de módulo en colores, lo que es útil para interpretar visualmente los resultados del clustering
    "

plotDendroAndColors(
  geneTree,
  dynamicColors,
  "Dynamic Tree Cut",
  dendroLabels = FALSE,
  hang = 0.03,
  addGuide = TRUE,
  guideHang = 0.05
)

"👉 Qué hace:
    Visualiza el dendrograma de genes junto con los colores de los módulos
    Esto te permite ver cómo se agrupan los genes y qué módulos se han identificado
    La función plotDendroAndColors es una herramienta útil para evaluar la calidad del clustering y la asignación de módulos
    Puedes ajustar parámetros como hang y addGuide para mejorar la visualización según tus datos
    "


table(dynamicColors)

  "numero de genes por modulo"

MEList <- moduleEigengenes(
  datExpr,
  colors = dynamicColors
)

"👉 Qué hace:
    Calcula los eigengenes de cada módulo, que son la primera componente principal de los genes en ese módulo
    Los eigengenes representan el patrón de expresión general del módulo y se pueden usar para correlacionar con rasgos o condiciones experimentales
    La función moduleEigengenes toma la matriz de expresión y los colores de los módulos para calcular estos eigengenes, que son fundamentales para análisis posteriores como 
    la correlación con fenotipos o la identificación de módulos relacionados con condiciones específicas
    "

MEs <- MEList$eigengenes

"👉 Qué hace:
    Extrae los eigengenes calculados para cada módulo
    Los eigengenes son vectores que representan la expresión promedio de los genes en cada módulo
    Puedes usar estos eigengenes para correlacionar con rasgos o condiciones experimentales, lo que te permite 
    identificar módulos que están asociados con características específicas de tus muestras
    La función moduleEigengenes es una parte crucial del análisis WGCNA, ya que proporciona una forma de
    resumir la información de cada módulo en un solo vector que se puede analizar más fácilmente
    "

# ============================================
# 📊 ANÁLISIS COMPLETO DEL DATASET DE MEs
# ============================================

cat("\n========== DIMENSIONES DEL DATASET ==========\n")
cat("Número de muestras:", nrow(MEs), "\n")
cat("Número de módulos:", ncol(MEs), "\n\n")

cat("========== PRIMERAS 10 MUESTRAS ==========\n")
print(head(MEs, 10))

cat("\n========== ÚLTIMAS 10 MUESTRAS ==========\n")
print(tail(MEs, 10))

cat("\n========== ESTADÍSTICAS DESCRIPTIVAS POR MÓDULO ==========\n")
summary(MEs)
