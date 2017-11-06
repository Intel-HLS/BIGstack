#!/bin/bash

echo "Downloading Reference Data for Hybrid workflow (if it doesn't already exist)"
GCP_PATH="https://storage.googleapis.com"
#Edit the below DATA_PATH to where you want the data to reside in your shared file system
DATA_PATH="/cluster_share/data/RefArch_Broad_data/"

cd $DATA_PATH/genomics-public-data/resources/broad/hg38/v0/
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/wgs_coverage_regions.hg38.interval_list
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/wgs_evaluation_regions.hg38.interval_list
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.contam.UD
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.contam.bed
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.contam.mu
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.contam.V

# This will download the data from the Intel-hosted GCP, which has controlled access. 
# Provide your Google ID to your Intel representative. 
# If the script does not download the files properly, try manually downloading 
# all the files directly from the webpage. 
# If you still have issues downloading these files, contact your Intel representative. 
mkdir -p $DATA_PATH/genomics-public-data/NA12878/bams/
cd $DATA_PATH/genomics-public-data/NA12878/bams/
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HJYFJCCXX.4.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HJYFJCCXX.5.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HJYFJCCXX.6.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HJYFJCCXX.7.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HJYFJCCXX.8.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HJYN2CCXX.1.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35MCCXX.1.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35MCCXX.2.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35MCCXX.3.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35MCCXX.4.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35MCCXX.5.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35MCCXX.6.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35MCCXX.7.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35MCCXX.8.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35NCCXX.1.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK35NCCXX.2.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK3T5CCXX.1.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK3T5CCXX.2.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK3T5CCXX.3.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK3T5CCXX.4.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK3T5CCXX.5.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK3T5CCXX.6.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK3T5CCXX.7.Pond-492100.unmapped.bam	
wget -nc -v -P $DATA_PATH/genomics-public-data/NA12878/bams \
$GCP_PATH/bigstackdata/G96830/NA12878/bams/HK3T5CCXX.8.Pond-492100.unmapped.bam	

cd $DATA_PATH/genomics-public-data/resources/broad/hg38/v0/
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/bigstackdata/G96830/NA12878/fingerprint_vcf/NA12878.hg38.reference.fingerprint.vcf


