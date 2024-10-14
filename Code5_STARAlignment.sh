#!/bin/bash
#Code 5
#  Star alignment 
# Exit immediately if a command exits with a non-zero status
set -e

# Set paths for STAR and SAMtools

Sam_Tools=$(which samtools)
STAR_Tools=$(which star)

export PATH=$PATH:Sam_Tools
export PATH=$PATH:STAR_Tools

# Define generic directories and variables
CORES=16  # Number of CPU cores to use
STAR_INDEXES="/path/to/STAR_indexes"  # Path to STAR genome indexes
FASTQ_PATH="/path/to/fastq_files"  # Path to FASTQ files
STAR_OUTPUT="/path/to/output_directory/Aligned"  # Output directory for BAM files

# Check if the user has provided a read type (single or paired)
READ_TYPE=$1  # User provides "single" or "paired" when running the script

# Loop through all sample files in the FASTQ directory
for FILE in ${FASTQ_PATH}/"SRR"*; do
    # Extract sample name
    SAMPLE=$(basename $FILE)

    # If READ_TYPE is "paired", run STAR alignment for paired-end reads
    if [ "$READ_TYPE" == "paired" ]; then
        # Set file paths for paired-end reads
        F1=${FILE}/"TrimOut"/${SAMPLE}_1_val_1.fq.gz
        F2=${FILE}/"TrimOut"/${SAMPLE}_2_val_2.fq.gz

        # Make output directory if it doesn't exist
        mkdir -p ${STAR_OUTPUT}

        # Run STAR for paired-end alignment
        echo "===== Running STAR for paired-end reads on $SAMPLE..."
        STAR --runThreadN ${CORES} \
            --genomeDir ${STAR_INDEXES} \
            --readFilesIn ${F1} ${F2} \
            --readFilesCommand zcat \
            --alignIntronMax 1000000 \
            --alignMatesGapMax 1000000 \
            --outSAMattributes NH HI NM MD \
            --outSAMtype BAM SortedByCoordinate \
            --outFileNamePrefix ${STAR_OUTPUT}/${SAMPLE}_paired

    # If READ_TYPE is "single", run STAR alignment for single-end reads
    elif [ "$READ_TYPE" == "single" ]; then
        # Set file path for single-end read
        F1=${FILE}/"TrimOut"/${SAMPLE}_trimmed.fq.gz

        # Make output directory if it doesn't exist
        mkdir -p ${STAR_OUTPUT}

        # Run STAR for single-end alignment
        echo "===== Running STAR for single-end reads on $SAMPLE..."
        STAR --runThreadN ${CORES} \
            --genomeDir ${STAR_INDEXES} \
            --readFilesIn ${F1} \
            --readFilesCommand zcat \
            --outSAMattributes NH HI NM MD \
            --outSAMtype BAM SortedByCoordinate \
            --outFileNamePrefix ${STAR_OUTPUT}/${SAMPLE}_single

    else
    echo "Invalid read type specified! Please use 'paired' or 'single'."
    exit 1
fi
    echo "===== Alignment complete for $SAMPLE"
    echo " "

done
