install.packages("readxl")

library(readxl)

annotations <- read_excel(
  "Gene_description.xlsx"
)


colnames(annotations)


annotations <- annotations[, c("Bgh ID", "Gene Description")]


head(purpleSummary)

purpleAnnotated <- merge(
  purpleSummary,
  annotations,
  by.x = "Gene",
  by.y = "Bgh ID",
  all.x = TRUE
)

# table(dynamicColors)

purpleAnnotated <- purpleAnnotated[
  order(-purpleAnnotated$kME),
]

head(purpleAnnotated, 20)