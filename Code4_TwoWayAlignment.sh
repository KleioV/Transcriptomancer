#!/bin/bash
### Code 4
## Two-way alignment : This was used only for paired-end and only on a small number of samples for evaluation 

#  directories and variables
FASTQ_PATH="/path/to/fastq_files"  # Directory containing FASTQ files
HISAT2_INDEXES="/path/to/hisat2_indexes"  # Directory containing HISAT2 indexes
BOWTIE2_INDEX="/path/to/bowtie2_indexes"  # Directory containing Bowtie2 indexes
HISAT2_OUTPUT="/path/to/output"  # Directory for output files
CORES=8  # Number of CPU cores to use for parallel processing

# Loop through all FASTQ files in the specified directory
for S in $(ls ${FASTQ_PATH}/*.fq.gz); do

    # Extract sample name without extension
    SAMPLE=$(basename $S .fq.gz)

    # HISAT2 alignment
    echo "===== Mapping with HISAT2 for $S..."
    hisat2 -p ${CORES} \
        --add-chrname \
        --un-conc ${HISAT2_OUTPUT}/${SAMPLE}_unmapped.fastq \
        -x ${HISAT2_INDEXES} \
        -1 ${FASTQ_PATH}/${SAMPLE}_R1.fastq.gz \
        -2 ${FASTQ_PATH}/${SAMPLE}_R2.fastq.gz \
        -S ${HISAT2_OUTPUT}/${SAMPLE}_hisat2.sam
    echo " "

    # Bowtie2 mapping of unmapped reads
    echo "===== Trying now to map unmapped reads with Bowtie2 for $SAMPLE..."
    bowtie2 --local --very-sensitive-local \
        -p ${CORES} \
        -x ${BOWTIE2_INDEX} \
        -1 ${HISAT2_OUTPUT}/${SAMPLE}_unmapped.1.fastq \
        -2 ${HISAT2_OUTPUT}/${SAMPLE}_unmapped.2.fastq | \
        samtools view -bhS -o ${HISAT2_OUTPUT}/${SAMPLE}_unmapped_remap_tmp.bad -
    echo "===== Merging all reads for $SAMPLE..."

    # Extract header from HISAT2 output and reheader Bowtie2 output
    samtools view -@ ${CORES} -HS ${HISAT2_OUTPUT}/${SAMPLE}_hisat2.sam > \
        ${HISAT2_OUTPUT}/${SAMPLE}_header.sam
    samtools reheader ${HISAT2_OUTPUT}/${SAMPLE}_header.sam \
        ${HISAT2_OUTPUT}/${SAMPLE}_unmapped_remap_tmp.bad > \
        ${HISAT2_OUTPUT}/${SAMPLE}_unmapped_remap_tmp.uns

    # Sort the remapped Bowtie2 output
    samtools sort -@ ${CORES} \
        ${HISAT2_OUTPUT}/${SAMPLE}_unmapped_remap_tmp.uns \
        -o ${HISAT2_OUTPUT}/${SAMPLE}_unmapped_remap.bam

    # Convert HISAT2 SAM output to BAM
    samtools view -@ ${CORES} -bhS ${HISAT2_OUTPUT}/${SAMPLE}_hisat2.sam > \
        ${HISAT2_OUTPUT}/${SAMPLE}_hisat2.bam

    # Merge HISAT2 BAM and Bowtie2 remapped BAM
    samtools merge -@ ${CORES} -f ${HISAT2_OUTPUT}/${SAMPLE}_tmp.bam \
        ${HISAT2_OUTPUT}/${SAMPLE}_hisat2.bam \
        ${HISAT2_OUTPUT}/${SAMPLE}_unmapped_remap.bam

    # Sort and index the merged BAM file
    echo "===== Coordinate sorting all reads for $SAMPLE..."
    samtools sort -@ ${CORES} ${HISAT2_OUTPUT}/${SAMPLE}_tmp.bam \
        -o ${HISAT2_OUTPUT}/${SAMPLE}.bam
    echo "===== Indexing all merged reads for $SAMPLE..."
    samtools index -@ ${CORES} ${HISAT2_OUTPUT}/${SAMPLE}.bam

    # Clean up intermediate files
    echo "===== Removing intermediate files for $SAMPLE..."
    rm ${HISAT2_OUTPUT}/${SAMPLE}_hisat2.bam \
       ${HISAT2_OUTPUT}/${SAMPLE}_tmp.bam \
       ${HISAT2_OUTPUT}/${SAMPLE}_unmapped*.fastq \
       ${HISAT2_OUTPUT}/${SAMPLE}_unmapped_remap.bam \
       ${HISAT2_OUTPUT}/${SAMPLE}_unmapped_remap_tmp.bad \
       ${HISAT2_OUTPUT}/${SAMPLE}_unmapped_remap_tmp.uns

    echo " "
done
