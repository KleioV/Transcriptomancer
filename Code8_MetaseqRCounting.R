#!/usr/bin/env Rscript

#Code 9 

# === MetaseqR2 Counting Script ===

# Load the necessary library
library(metaseqR2)

# Set a seed for reproducibility
set.seed(42)

# === Define paths and parameters ===
# Path to the sample list (a tab-delimited file with sample metadata)
sampleList <- "/path/to/SampleList.txt"

# Path to the local annotation database in SQLite format
localDb <- file.path("/path/to/annotation.sqlite")

# Define the output directory for the counting results
outputDir <- file.path("/path/to/Counted")

# === Run the MetaseqR2 pipeline ===
metaseqr2(
    sampleList = sampleList,       # Sample list file path
    contrast = c("A_vs_I"),        # Specify the comparison of interest (e.g., A vs. I)
    localDb = localDb,             # Local annotation database
    org = "hg38",                  # Organism (e.g., human genome version hg38)
    countType = c("gene"),         # Count type (gene-level counts)
    normalization = "none",        # Normalization method (set to "none" in this case)
    statistics = c("deseq2"),      # Statistical method to use (DESeq2)
    figFormat = "png",             # Format of the QC plots
    qcPlots = c("mds"),            # Quality control plots to generate (MDS plot)
    createTracks = FALSE,          # Do not create genome browser tracks
    restrictCores = 0.1,           # Restrict cores to 10% of available resources
    exportWhat = c("annotation", "counts"), # Export both annotation and raw counts
    exportValues = c("raw"),       # Export raw counts
    exportCountsTable = TRUE,      # Export the counts table
    exportWhere = outputDir        # Directory to store the output files
)

# === Output ===
# The counting results, including raw counts and annotation, will be saved to the specified directory.
