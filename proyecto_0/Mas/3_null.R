# --- DIAGNÓSTICO DE VALORES NA (NA) ---
total_na <- sum(is.na(datExpr))
print(paste("Total de valores NA:", total_na))

# NAs por muestra (columna)
na_por_muestra <- colSums(is.na(datExpr))
print("Valores NA por muestra:")
print(na_por_muestra[na_por_muestra > 0]) # Solo muestra las que tienen NAs

# --- DIAGNÓSTICO DE VALORES CERO (0) ---

# 1. Cantidad total de ceros
total_ceros <- sum(datExpr == 0)
porcentaje_ceros <- (total_ceros / (nrow(datExpr) * ncol(datExpr))) * 100

cat("\n--- Reporte de Ceros ---\n")
cat("Total de ceros en la tabla:", total_ceros, "\n")
cat("Porcentaje de 'sparsity' (ceros):", round(porcentaje_ceros, 2), "%\n")

# 2. Ceros por muestra (¿Qué muestras tienen menos lecturas?)
ceros_por_columna <- colSums(datExpr == 0)
prop_ceros_col <- colMeans(datExpr == 0) * 100

# Crear un resumen ordenado de las muestras con más ceros
resumen_ceros <- data.frame(
  Muestra = names(ceros_por_columna),
  Cantidad_Ceros = ceros_por_columna,
  Porcentaje = round(prop_ceros_col, 2)
)

# Ordenar de mayor a menor cantidad de ceros
resumen_ceros <- resumen_ceros[order(-resumen_ceros$Cantidad_Ceros), ]

cat("\nTop 10 muestras con mayor cantidad de ceros:\n")
print(head(resumen_ceros, 10))

# 3. Visualización rápida de la distribución de ceros
barplot(resumen_ceros$Porcentaje, 
        names.arg = resumen_ceros$Muestra, 
        las = 2, 
        cex.names = 0.7,
        main = "Porcentaje de ceros por muestra",
        col = "skyblue",
        ylab = "% de Genes con cero conteos")