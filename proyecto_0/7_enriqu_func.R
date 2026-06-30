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


universo_MF <- unique(
  TERM2GENE_MF$GENE
)

MF_purple <- enricher(
  
  gene = genes_purple,
  
  universe = universo_MF,
  
  TERM2GENE = TERM2GENE_MF,
  
  pvalueCutoff = 0.05,
  
  pAdjustMethod = "BH",
  
  minGSSize = 2
)

MF_results <- as.data.frame(
  MF_purple
)

head(
  MF_results,
  20
)

dotplot(
  MF_purple,
  showCategory = 15,
  title="Molecular Function - Purple module"
)

sum(genes_purple %in% TERM2GENE_MF$GENE)

purple_MF <- TERM2GENE_MF %>%
  filter(
    GENE %in% genes_purple
  )


table(purple_MF$TERM) %>%
  sort(decreasing = TRUE) %>%
  head(20)