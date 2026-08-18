library(clusterProfiler)
library(enrichplot)
library(readxl)
library(tidyverse)


############################################################
# 1. Cargar tabla de anotaciones
############################################################

genes_info <- read_excel(
   "Gene_description_con_Modulos.xlsx",
    col_types = c(
     "text",  # Gene_ID
     "text",  # Gene Description
     "text",  # Modulo
     "text",  # Biological_Process
     "text"   # Molecular_Function
  )
)

colnames(genes_info)[1] <- "Gene_ID"

bp_col <- which(
  str_detect(
    tolower(colnames(genes_info)),
    "biological"
  )
)

colnames(genes_info)[bp_col] <- "Biological_Process"

head(bp_col)


############################################################
# 2. Biological_Process
############################################################

TERM2GENE <- genes_info %>%
  
  select(
    Gene_ID,
    Biological_Process
  ) %>%
  
  drop_na(
    Biological_Process
  ) %>%
  
  separate_rows(
    Biological_Process,
    sep = ";"
  ) %>%
  
  mutate(
    Biological_Process = trimws(Biological_Process)
  ) %>%
  
  filter(
    Biological_Process != ""
  ) %>%
  
  select(
    TERM = Biological_Process,
    GENE = Gene_ID
  ) %>%
  
  distinct()


TERM2NAME <- TERM2GENE %>%
  
  distinct(
    TERM
  ) %>%
  
  mutate(
    NAME = TERM
  )

head(TERM2GENE)


genes_purple <- genes_info %>%
  filter(Modulo == "purple") %>%
  pull(Gene_ID)

length(genes_purple)


sum(genes_purple %in% TERM2GENE$GENE)

universo <- unique(TERM2GENE$GENE)

length(universo)


library(clusterProfiler)

GO_purple <- enricher(
  
  gene = genes_purple,
  
  universe = universo,
  
  TERM2GENE = TERM2GENE,
  
  pvalueCutoff = 0.05,
  
  pAdjustMethod = "BH",
  
  minGSSize = 3,
  
  maxGSSize = 500
)

GO_results <- as.data.frame(GO_purple)

head(
  GO_results,
  20
)


purple_GO <- TERM2GENE %>%
  filter(
    GENE %in% genes_purple
  )

head(purple_GO,20)

GO_purple_exploratorio <- enricher(
  
  gene = genes_purple,
  
  universe = universo,
  
  TERM2GENE = TERM2GENE,
  
  pvalueCutoff = 1,
  
  minGSSize = 1,
  
  maxGSSize = 500
)

GO_exploratorio <- as.data.frame(
  GO_purple_exploratorio
)

head(
  GO_exploratorio,
  20
)

table(purple_GO$TERM) %>% sort(decreasing = TRUE) %>% head(20)
