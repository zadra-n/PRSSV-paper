

library(tidyr)
library(gplots)
library("RColorBrewer")
library(pheatmap)
library(dplyr)
library(stringr)
library(ggplot2)

df <- read.table("distance_matrix_hanta.csv", sep = ",",header = TRUE, row.names = 1)
df_sym <- df
df_sym[upper.tri(df_sym)] <- t(df_sym)[upper.tri(df_sym)]

p <- pheatmap(df_sym, main="Hanta p-distance",  cellwidth = 10, cellheight = 10, angle_col=45, cutree_rows=4, cutree_cols=4, treeheight_row= 200, treeheight_col =200, fontsize = 15, fontsize_col= 10, fontsize_row= 10)


ggsave('prova_hanta.pdf', plot = p, dpi = 600, limitsize = FALSE, width = 200 , height =200, units = 'cm')
help(ggsave)
  