data <- read.table(
"tabla_conteo/GSE43163_CompleteCountTable_Bgh.txt",
header=TRUE,
row.names=1,
sep="\t"
)

dim(data)

head(data)

colSums(data)     # tamaño de librería
summary(data)     # distribución