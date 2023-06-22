#!/bin/bash
#SBATCH -D /home/jdfudyma/TESTREFORMAT
#SBATCH --job-name=trimmomatic
#SBATCH --nodes=1
#SBATCH -t 12:00:00
#SBATCH --ntasks=8
#SBATCH --output=./out/trimmomatic_%j.out
#SBATCH --error=./err/trimmomatic_%j.err
#SBATCH --partition=high2

# load modules
module load deprecated/java

# define files
files=*_R1_*

#change into working directory
cd raw


# Do trimmomatic, PE = paired end
# Scan the read with a 4-base wide sliding window,
# cutting when the average quality per base drops below 30, minlenght = 50
for f in $files; do
    echo $f
    java -jar /home/amhorst/programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 8 -phred33 \
    ${f%%_R1*}_R1_001.fastq.gz \
    ${f%%_R1*}_R2_001.fastq.gz \
    ../trimmed/${f%%_R1*}_R1_trimmed.fq.gz \
    ../trimmed/unpaired/${f%%_R1*}_R1_Unpaired.fq.gz \
    ../trimmed/${f%%_R1*}_R2_trimmed.fq.gz \
    ../trimmed/unpaired/${f%%_R1*}_R2_Unpaired.fq.gz \
    ILLUMINACLIP:/home/amhorst/programs/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
    SLIDINGWINDOW:4:30 MINLEN:50 && mv ${f%%_R1*}_R1_001.fastq.gz ./done && mv ${f%%_R1*}_R2_001.fastq.gz ./done ; done ;

#print memory, time reesources etc .. see if this ends up anywhere...
/usr/bin/time -v ls
