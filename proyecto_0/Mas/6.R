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

############################################################
# 2. Molecular_Function
############################################################

TERM2GENE_MF <- genes_info %>%
  
  select(
    Gene_ID,
    Molecular_Function
  ) %>%
  
  drop_na(
    Molecular_Function
  ) %>%
  
  separate_rows(
    Molecular_Function,
    sep=";"
  ) %>%
  
  mutate(
    Molecular_Function = trimws(Molecular_Function)
  ) %>%
  
  filter(
    Molecular_Function != ""
  ) %>%
  
  select(
    TERM = Molecular_Function,
    GENE = Gene_ID
  ) %>%
  
  distinct()

