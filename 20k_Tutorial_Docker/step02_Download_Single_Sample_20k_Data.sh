#! /bin/bash
echo "BIGStack Tutorial Step 2"
echo "Downloading Reference Data (if it doesn't already exist)"
GCP_PATH="https://storage.googleapis.com"
#Edit the below DATA_PATH to where you want the data to reside in your shared file system
DATA_PATH="/cluster_share/data/RefArch_Broad_data"

mkdir -p $DATA_PATH/genomics-public-data/resources/broad/hg38/v0
cd $DATA_PATH/genomics-public-data/resources/broad/hg38/v0
echo "Downloading the reference files"
#Reference Genome
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.dict
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.fasta
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.fasta.fai
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.fasta.64.alt
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.fasta.64.sa
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.fasta.64.amb
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.fasta.64.bwt
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.fasta.64.ann
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.fasta.64.pac
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.contam.UD
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.contam.bed
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.contam.mu
echo "Done downloading reference files"
sleep 1
echo "Downloading the resource files"
#Resource Files
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi
echo "Done downloading resource files"
sleep 1
echo "Downloading the intervals files"
#Interval Files
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/wgs_calling_regions.hg38.interval_list
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/wgs_coverage_regions.hg38.interval_list
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/broad-references/hg38/v0/wgs_coverage_regions.hg38.interval_list
echo "Done downloading interval files"
sleep 1
echo "Downloading 20k Test Data for Single Sample Workflow"
mkdir -p $DATA_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878
cd $DATA_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878
wget -nc -v -P $DATA_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878 \
$GCP_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878/H06HDADXX130110.1.ATCACGAT.20k_reads.bam
wget -nc -v -P $DATA_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878 \
$GCP_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878/H06HDADXX130110.2.ATCACGAT.20k_reads.bam
wget -nc -v -P $DATA_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878 \
$GCP_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878/H06JUADXX130110.1.ATCACGAT.20k_reads.bam
chmod -R 777 $DATA_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878
echo "Data for tutorial downloaded successfully"

