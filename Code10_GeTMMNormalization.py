#!/usr/bin/env python3

#Code 10

# === GeTMM Normalization Script ===

# Import necessary libraries
import pandas as pd
import numpy as np
from scipy.stats import gmean

# === Define Paths and Parameters ===
count_matrix_file = "path/to/filtered_count_matrix.csv"  # Path to count matrix CSV file
gtf_file = "path/to/mart_export.txt"                    # Path to gene annotation GTF file
read_length = 100                                       # Read length in base pairs (bp)

# === Load Data ===
# Open the count matrix file using pandas
count_matrix_df = pd.read_csv(count_matrix_file, sep=",", index_col=0)
print("Count matrix preview:\n", count_matrix_df.head())

# Open the gene annotation file using pandas
gene_df = pd.read_csv(gtf_file, sep="\t", comment="#", header=None,
                      names=["Gene stable ID", "gene_name", "seqname", "start", "end", "strand", "exon_name"])
print("Gene annotation preview:\n", gene_df.head())

# === Preprocess Data ===
# Calculate gene lengths (end - start + 1)
gene_df["gene_length"] = gene_df["end"] - gene_df["start"] + 1

# Group by gene name to get the average gene length
gene_lengths = gene_df.groupby("gene_name")["gene_length"].mean()

# Transpose the count matrix (samples as rows, genes as columns)
count_matrix_df = count_matrix_df.transpose()

# === Normalize Read Counts Using GeTMM Method ===
# Normalize by the sum of counts per sample (counts per million - CPM)
count_matrix_df_norm = count_matrix_df.div(count_matrix_df.sum(), axis=1)

# Apply log transformation
count_matrix_df_norm_log = np.log2(count_matrix_df_norm * 1e6 + 1)

# Initialize an array to store GeTMM normalization factors
geTMM_factors = np.zeros(len(count_matrix_df_norm_log))

# Compute GeTMM factors for each sample
for i in range(len(count_matrix_df_norm_log)):
    sample_exprs = count_matrix_df_norm_log.iloc[i, :]  # Expression values for a sample
    sample_lengths = np.array([gene_lengths[gene] for gene in sample_exprs.index])  # Corresponding gene lengths
    
    # Calculate expression and length ratios
    exprs_ratios = np.exp(sample_exprs - gmean(sample_exprs))
    lengths_ratios = np.power(sample_lengths / gmean(sample_lengths), read_length)
    
    # Compute GeTMM factor for this sample
    geTMM_factors[i] = np.power(np.prod(np.power(exprs_ratios, lengths_ratios)), 1 / np.sum(lengths_ratios))

# Normalize the read counts by GeTMM factors
count_matrix_df_norm_geTMM = count_matrix_df_norm / geTMM_factors

# Transpose the normalized count matrix back (genes as rows, samples as columns)
count_matrix_df_norm_geTMM = count_matrix_df_norm_geTMM.transpose()

# === Output ===
# Print the GeTMM-normalized read counts
print("GeTMM-normalized counts:\n", count_matrix_df_norm_geTMM)
