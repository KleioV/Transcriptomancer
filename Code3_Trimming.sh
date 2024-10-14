#!/bin/bash
### Code 3
## Trimming the fastq files

HOME_PATH=~/PhD/Downloaded
TRIMGALORE_COMMAND=$(which trim_galore)
CORES=8
FASTQC=$(which fastqc)
export PATH=$PATH:$FASTQC

# depending on the fastqs type

if [ "$READ_TYPE" == "paired" ]; then
	echo "Trimming paired-end reads..."
	# for each samples
	for FILE in $HOME_PATH/"SRR"*
	do
		SAMPLE=`basename $FILE`
		echo $SAMPLE
		mkdir -p $HOME_PATH/$SAMPLE/"TrimOut"
		F1=$HOME_PATH/$SAMPLE/$SAMPLE"_1.fastq.gz"
		F2=$HOME_PATH/$SAMPLE/$SAMPLE”_2.fastq.gz"
		$TRIMGALORE_COMMAND \
			--paired \
			--q 30 \
			--length 50 \
			--output_dir $HOME_PATH/$SAMPLE/"TrimOut" \
			--path_to_cutadapt /usr/bin/cutadapt \
			--cores $CORES \
			--fastqc \
			--trim-n $F1 $F2
	done

elif [ "$READ_TYPE" == "single" ]; then
    echo "Trimming single-end reads..."
	# for each samples
	for FILE in `ls $HOME_PATH/"SRR"*`
	do
	    SAMPLE=`basename $FILE`
	    echo $SAMPLE
	    mkdir -p $HOME_PATH/$SAMPLE/"TrimOut"
	    F1=$HOME_PATH/$SAMPLE/$SAMPLE".fastq.gz"
	    
	    $TRIMGALORE_COMMAND \
	        --q 30 \
	        --length 50 \
	        --output_dir $HOME_PATH/$SAMPLE/"TrimOut" \
	        --path_to_cutadapt /usr/bin/cutadapt \
	        --cores $CORES \
	        --fastqc \
	        --trim-n $F1
	    if [ -f  $TRIMGALORE_OUTPUT/$BASE"_R1_001_unpaired_1.fq.gz" ]
	    then
	        rm $HOME_PATH/$SAMPLE/"TrimOut"/*"unpaired_1.fq.gz"
	    fi
	done

else
    echo "Invalid read type specified! Please use 'paired' or 'single'."
    exit 1
fi

rm $HOME_PATH/$SAMPLE/"TrimOut"/*"unpaired_1.fq.gz"
rm $HOME_PATH/$SAMPLE/"TrimOut"/*"unpaired_2.fq.gz"