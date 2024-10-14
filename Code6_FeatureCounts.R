#!/usr/bin/env Rscript

## Code 6 

# Define the function to run featureCounts based on the read type (single or paired)

## Note: files a character vector giving names of input files containing read mapping results. The files can be in either SAM format or BAM format. The file format is automatically detected by the function.

run_featureCounts <- function(files, READ_TYPE) {
  
  # Set general featureCounts parameters
  annot.inbuilt <- "hg38"  # Built-in genome annotation
  annot.ext <- NULL  # External annotation file (if any)
  isGTFAnnotationFile <- FALSE  # Whether the annotation file is in GTF format
  GTF.featureType <- "exon"  # Feature type to count (e.g., exon, gene)
  GTF.attrType <- "gene_id"  # Attribute type in GTF to count
  chrAliases <- NULL  # Chromosome alias table (if any)
  useMetaFeatures <- TRUE  # Count meta-features (e.g., genes instead of exons)
  allowMultiOverlap <- FALSE  # Disallow multi-overlap
  minOverlap <- 1  # Minimum overlap required to count
  largestOverlap <- FALSE  # Consider largest overlap only
  readExtension5 <- 0  # Extend reads upstream
  readExtension3 <- 0  # Extend reads downstream
  read2pos <- NULL  # Position of reads (if specified)
  countMultiMappingReads <- FALSE  # Ignore multi-mapping reads
  fraction <- FALSE  # Do not fractionally count reads
  minMQS <- 0  # Minimum mapping quality score
  splitOnly <- FALSE  # Do not count split reads only
  nonSplitOnly <- FALSE  # Do not count only non-split reads
  primaryOnly <- FALSE  # Consider primary alignments only
  ignoreDup <- FALSE  # Do not ignore duplicate reads
  strandSpecific <- 0  # Strand specificity (0 = unstranded)
  juncCounts <- FALSE  # Do not count junction reads
  genome <- NULL  # Genome file (if any)
  
  # Paired-end specific parameters
  isPairedEnd <- FALSE
  requireBothEndsMapped <- FALSE
  checkFragLength <- FALSE
  minFragLength <- 50
  maxFragLength <- 600
  countChimericFragments <- TRUE
  autosort <- TRUE

  # Check if the reads are paired-end or single-end
  if (READ_TYPE == "paired") {
    isPairedEnd <- TRUE
    requireBothEndsMapped <- TRUE  # Require both ends to be mapped for paired-end reads
    checkFragLength <- TRUE  # Check fragment length
    message("Running featureCounts for paired-end reads...")
    
  } else if (READ_TYPE == "single") {
    isPairedEnd <- FALSE
    message("Running featureCounts for single-end reads...")
    
  } else {
    stop("Error: Invalid READ_TYPE. Please use 'single' or 'paired'.")
  }
  
  # Run featureCounts
  featureCounts(files = files,
                annot.inbuilt = annot.inbuilt,
                annot.ext = annot.ext,
                isGTFAnnotationFile = isGTFAnnotationFile,
                GTF.featureType = GTF.featureType,
                GTF.attrType = GTF.attrType,
                chrAliases = chrAliases,
                useMetaFeatures = useMetaFeatures,
                allowMultiOverlap = allowMultiOverlap,
                minOverlap = minOverlap,
                largestOverlap = largestOverlap,
                readExtension5 = readExtension5,
                readExtension3 = readExtension3,
                read2pos = read2pos,
                countMultiMappingReads = countMultiMappingReads,
                fraction = fraction,
                minMQS = minMQS,
                splitOnly = splitOnly,
                nonSplitOnly = nonSplitOnly,
                primaryOnly = primaryOnly,
                ignoreDup = ignoreDup,
                strandSpecific = strandSpecific,
                juncCounts = juncCounts,
                genome = genome,
                
                # Paired-end specific parameters
                isPairedEnd = isPairedEnd,
                requireBothEndsMapped = requireBothEndsMapped,
                checkFragLength = checkFragLength,
                minFragLength = minFragLength,
                maxFragLength = maxFragLength,
                countChimericFragments = countChimericFragments,
                autosort = autosort)
}

# Example usage:
# run_featureCounts(files = your_files, READ_TYPE = "paired")  # For paired-end reads
# run_featureCounts(files = your_files, READ_TYPE = "single")  # For single-end reads

