gsg <- goodSamplesGenes(datExpr, verbose = 3)

"Aquí estamos usando la función goodSamplesGenes del paquete WGCNA para verificar 
la calidad de nuestros datos antes de realizar análisis más avanzados. 
Esta función nos ayuda a identificar genes y muestras que podrían ser problemáticos
 debido a valores faltantes (NA) o varianza cero.
 
 resultado: 43 genes y 0 muestras no son buenos, lo que significa que no tienen
  datos completos o tienen varianza cero.
 "

sum(!gsg$goodGenes)
sum(!gsg$goodSamples)

"Aqui se demustra que no hay muestras problemáticas, pero sí hay 43 genes que
 podrían causar problemas en el análisis
 debido a datos faltantes o varianza cero. 
 Es importante revisar estos genes para decidir si se deben eliminar 
 o investigar más a fondo antes de continuar con el análisis."

badGenes <- colnames(datExpr)[!gsg$goodGenes]

badGenes

apply(datExpr[, badGenes], 2, var)

"Se observa que estos genes tienen varianza cero, lo que significa que no varían entre 
las muestras. 
 Esto puede ser problemático para análisis como clustering o PCA, ya que no aportan 
 información útil. 
 En general, es recomendable eliminar estos genes del análisis para mejorar la calidad 
 de los resultados."


datExpr <- datExpr[, gsg$goodGenes]


gsg <- goodSamplesGenes(datExpr)