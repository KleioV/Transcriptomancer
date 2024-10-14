#!/usr/bin/env python3

#Code 8 

# In-House Counting Script for RNA-seq BAM files

import pysam
import pandas as pd
import numpy as np
from scipy.stats import gmean

# === Define paths and parameters ===
bam_files = ["sample1.bam", "sample2.bam", "sample3.bam"]  # List of BAM file paths
gtf_file = "path/to/genes.gtf"  # Path to the gene annotation file (GTF format)
read_length = 100  # Define the read length in base pairs (bp)

# === Load gene annotation file ===
# The GTF file is read into a pandas DataFrame, excluding comment lines (lines starting with '#')
gene_df = pd.read_csv(gtf_file, sep="\t", comment="#", header=None,
                      names=["seqname", "source", "feature", "start", "end", "score", "strand", "frame", "attribute"])

# Extract gene names from the 'attribute' column using a regular expression
gene_df["gene_name"] = gene_df["attribute"].str.extract(r'gene_name "(.+?)"')

# Calculate gene lengths by subtracting the start from the end and adding 1
gene_df["gene_length"] = gene_df["end"] - gene_df["start"] + 1

# Group by gene name and calculate the mean gene length
gene_lengths = gene_df.groupby("gene_name")["gene_length"].mean()

# === Initialize dictionary for read counts ===
# Create a dictionary to store raw read counts for each gene in each sample
gene_counts_dict = {bam_file: {} for bam_file in bam_files}

# === Count reads overlapping each gene ===
# Loop through each BAM file and count the number of reads that overlap each gene
for bam_file in bam_files:
    # Open the BAM file for reading using pysam
    bam = pysam.AlignmentFile(bam_file, "rb")
    
    # Iterate over each gene and its length
    for gene, gene_length in gene_lengths.items():
        # Count the number of reads overlapping the gene using pysam's count function
        gene_counts_dict[bam_file][gene] = bam.count(contig=gene, start=1, end=gene_length, read_callback="all")
    
    # Close the BAM file after counting
    bam.close()

# === Convert read counts to a DataFrame ===
# Convert the raw read counts stored in the dictionary to a pandas DataFrame
gene_counts_df = pd.DataFrame.from_dict(gene_counts_dict)

# === Output ===
# The resulting DataFrame 'gene_counts_df' contains the raw counts of reads overlapping each gene for each sample.
