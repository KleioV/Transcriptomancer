#!/usr/bin/env Rscript

# Code 11
# === Transform Counts to Ranks ===
# This script reads a matrix of raw read counts, ranks the genes within each sample, 
# and writes the ranked matrix to an output file. The RawRead_PC_unranked_Noduplicated.txt is the count matrix in which
# only the Protein coding genes are included. Be sure that there are no dublications in the gene names. 

# === Libraries ===
# No additional libraries are required as we use base R functions.

# === Define Input and Output Files ===
input_file <- "path/to/Counted_Batch1_2_RawRead_PC_unranked_Noduplicated.txt"
output_file <- "path/to/Counted_Batch1_2_RawRead_PC_ranked.txt"

# === Load Input Matrix ===
# Load the input matrix from the specified file (genes as rows, samples as columns)
matrix <- read.table(input_file, header = TRUE, row.names = 1, sep = "\t")
cat("Input matrix loaded successfully.\n")

# === Rank Genes Within Each Sample ===
# Apply the 'rank' function to each column (sample), resolving ties by assigning the minimum rank
rank_matrix <- apply(matrix, 2, rank, ties.method = "min")
cat("Gene ranking completed.\n")

# === Write Output Matrix ===
# Write the ranked matrix to the specified output file
write.table(rank_matrix, file = output_file, sep = "\t", quote = FALSE)
cat("Ranked matrix written to file:", output_file, "\n")
