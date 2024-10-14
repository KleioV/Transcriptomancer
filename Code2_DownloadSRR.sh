#!/bin/bash

### Code 2
## Commant for Downloading the GEO to SRR
## Reminder: paired-end reads need "--split-files"
## SRR_names.txt has the SRR translated names 

SRA_Tools=$(which sratools.3.0.0)

export PATH=$PATH:SRA_Tools

HOME_PATH=~/PhD/Downloaded

READ_TYPE=$1  # Accepts "paired" or "single"

if [ "$READ_TYPE" == "paired" ]; then
    echo "Downloading paired-end reads..."
	for i in $(cat SRR_names.txt) 
	do 
		echo $i 
		date
		fastq-dump --gzip --split-files --outdir ./$i $i
	done

elif [ "$READ_TYPE" == "single" ]; then
    echo "Downloading single-end reads..."
	for i in $(cat SRR_names.txt) 
	do 
		echo $i 
		date
		fastq-dump --gzip --outdir ./$i $i
	done

else
    echo "Invalid read type specified! Please use 'paired' or 'single'."
    exit 1
fi

