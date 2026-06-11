install.packages("readxl")

library(readxl)

annotations <- read_excel(
  "Gene_description_con_Modulos.xlsx"
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

# table(dynamicColors)

purpleAnnotated <- purpleAnnotated[
  order(-purpleAnnotated$kME),
]

head(purpleAnnotated, 20)