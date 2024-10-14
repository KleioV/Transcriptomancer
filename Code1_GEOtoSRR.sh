#!/bin/bash

### Code 1
## Translating  GEO to SRR

# The SampleName.txt includes all the samples names in GEO, one in each row

HOME_PATH=~/PhD/Downloaded
TRIMGALORE_COMMAND=$(which trimgalore)

for i in $(cat SampleName.txt); do
    pysradb gsm-to-srr $i >> SRR_names.txt
done