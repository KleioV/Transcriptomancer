#!/bin/bash

# Code 9: L=Hlep function for creating the SampleList.txt
# === Sample List Creation Script ===

# Define paths and variables
HOME_PATH="/path/to/NowCounting/Counted_Batch3"    # Path to home directory
FASTQ_PATH="$HOME_PATH"                            # Path to FASTQ files (not used here but defined)
BAM_PATH="$HOME_PATH"                              # Path to BAM files

# Define the output file for the sample list
REPORT="$HOME_PATH/SampleList.txt"

# Print the header for the sample list (tab-separated columns)
printf "%s\t%s\t%s\t%s\n" "UniqueSampleName" "PathToBam" "Label" "Reads" > "$REPORT"

# === Process BAM files ===
# Loop through each BAM file in the directory and generate the sample list
for FILE in "$BAM_PATH"/*.bam; do
    # Extract the base name of the BAM file, removing 'Aligned.sortedByCoord.out.bam' from the name
    BASE=$(basename "$FILE" | sed 's/Aligned\.sortedByCoord\.out\.bam//')

    # Print the information to the sample list file
    printf "%s\t" "$BASE" >> "$REPORT"             # Print the unique sample name
    printf "%s\t" "$FILE" >> "$REPORT"             # Print the full path to the BAM file
    printf "%s\t" "A" >> "$REPORT"                 # Label (for example, A)
    printf "%s\n" "paired" >> "$REPORT"            # Specify the read type (e.g., paired)
done

# === Output ===
# The final sample list is saved in 'NowCounting_TracksSampleList.txt'

