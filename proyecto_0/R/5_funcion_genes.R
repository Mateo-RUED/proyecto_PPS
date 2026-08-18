
library(readxl)

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

# table(dynamicColors)

purpleAnnotated <- purpleAnnotated[
  order(-purpleAnnotated$kME),
]

head(purpleAnnotated, 20)