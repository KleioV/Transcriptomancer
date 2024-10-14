### Code Zero
## Bash Installations

#Install pysradb for SRR translation:
pip install pysradb

#Install SRA Toolkit for downloading sequencing data (fastq-dump):
sudo apt-get install sra-toolkit

#Install Trimgalore for trimming:
wget https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.zip
unzip 0.6.6.zip
export PATH=$PATH:/path_to/TrimGalore-0.6.6

#Install FastQC for quality control:
sudo apt-get install fastqc

#Install SAMtools for processing SAM/BAM files:
sudo apt-get install samtools

#Install STAR for RNA-seq alignment:
wget https://github.com/alexdobin/STAR/archive/2.7.6a.tar.gz
tar -zxvf STAR-2.7.6a.tar.gz
export PATH=$PATH:/path_to/STAR-2.7.6a/bin/Linux_x86_64

## ~ ~ I dont provide installations for the rest aligners, since i used them only for validation of the time they need to run

#Install featureCounts:
sudo apt-get install subread