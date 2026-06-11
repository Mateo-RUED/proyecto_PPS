library(ggplot2)

gene <- "bgh06162"

df <- data.frame(
  Expression = datExpr[, gene],
  K1 = factor(traitData$K1)
)

ggplot(df, aes(K1, Expression)) +
  geom_boxplot()