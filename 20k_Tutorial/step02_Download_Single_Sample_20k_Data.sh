#/bin/bash
echo "BIGStack Tutorial Step 2"
echo "Downloading Reference Data (if it doesn't already exist)"
GCP_PATH="https://storage.googleapis.com"
#Edit the below DATA_PATH to where you want the data to reside in your shared file system
DATA_PATH="/mnt/app_hdd/scratch/aprabh2"

mkdir -p $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.alt
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.sa
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.amb
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.bwt
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.ann
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.pac
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/1000G_omni2.5.hg38.vcf.gz
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/1000G_phase1.snps.high_confidence.hg38.vcf.gz
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/hapmap_3.3.hg38.vcf.gz.tbi
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/1000G_omni2.5.hg38.vcf.gz.tbi
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/1000G_phase1.snps.high_confidence.hg38.vcf.gz.tbi
echo "Done downloading Reference-files"
sleep 1
echo "Downloading the intervals files"
mkdir -p $DATA_PATH/RefArch_Broad_data/gatk-test-data/intervals
wget -nc -v -P $DATA_PATH/RefArch_Broad_data/gatk-test-data/intervals \
$GCP_PATH/gatk-test-data/intervals/hg38_wgs_scattered_calling_intervals.txt
mkdir -p $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0/scattered_calling_intervals/
for i in `seq 0001 0050`; do
  # get the $base files and put into folder for $base
  if [ "$i" -lt "10" ]; then
     base="000"$i
  else
     base="00"$i
  fi
  cd $DATA_PATH/RefArch_Broad_data/genomics-public-data/resources/broad/hg38/v0/scattered_calling_intervals/
  mkdir temp\_$base\_of\_50
  cd temp\_$base\_of\_50
  temppath=temp\_$base\_of\_50
  wget -PO $GCP_PATH/genomics-public-data/resources/broad/hg38/v0/scattered_calling_intervals/$temppath/scattered.interval_list
  mv O/scattered.interval_list .
  rm -rf O/
  cd ../
done
echo "Done downloading the intervals files"
sleep 1
echo "Downloading 20k Test Data for Single Sample Workflow to $DATA_PATH/20k"
sleep 1
mkdir -p $DATA_PATH/20k
cd $DATA_PATH/20k
wget -nc -v -P $DATA_PATH/20k \
$GCP_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878/H06HDADXX130110.1.ATCACGAT.20k_reads.bam
wget -nc -v -P $DATA_PATH/20k \
$GCP_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878/H06HDADXX130110.2.ATCACGAT.20k_reads.bam
wget -nc -v -P $DATA_PATH/20k \
$GCP_PATH/genomics-public-data/test-data/dna/wgs/hiseq2500/NA12878/H06JUADXX130110.1.ATCACGAT.20k_reads.bam
chmod -R 777 $DATA_PATH/20k
echo "Data downloaded successfully"
