data <- read.table(
"tabla_conteo/GSE43163_CompleteCountTable_Bgh.txt",
header=TRUE,
row.names=1,
sep="\t"
)

head(rownames(data))


dim(data)

head(rownames(data),20)

colnames(data)




