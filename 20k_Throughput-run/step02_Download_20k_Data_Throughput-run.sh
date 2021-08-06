#! /bin/bash
# Copyright (c) 2019 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License"); # you may not use this file except in compliance with the License.
# You may obtain a copy of the License at #
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software # distributed under the License is distributed on an "AS IS" BASIS, # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and # limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

echo "Downloading Reference Data (if it doesn't already exist)"
GCP_PATH="https://storage.googleapis.com"
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#specify the path to data download directory.By default, data is downloaded to current folder
DATA_PATH="$BASEDIR/data"
mkdir -p $DATA_PATH/genomics-public-data/resources/broad/hg38/v0
cd $DATA_PATH/genomics-public-data/resources/broad/hg38/v0
echo "Downloading the reference files"
#Reference Genome
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.fai
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.alt
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.sa
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.amb
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.bwt
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.ann
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta.64.pac
echo "Done downloading reference files"
sleep 1
echo "Downloading the resource files"
#Resource Files
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi
echo "Done downloading resource files"
sleep 1
echo "Downloading the intervals files"
#Interval Files
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/genomics-public-data/resources/broad/hg38/v0/wgs_calling_regions.hg38.interval_list
wget -nc -v -P $DATA_PATH/genomics-public-data/resources/broad/hg38/v0 \
$GCP_PATH/gcp-public-data--broad-references/hg38/v0/wgs_evaluation_regions.hg38.interval_list

#Alternatively  gsutil cp -r gs://genomics-public-data/references/hg38/v0/* .
 wget -nc -v -P $DATA_PATH/genomics-public-data/references/broad/hg38/v0/ \
$GCP_PATH/genomics-public-data/references/hg38/v0/wgs_coverage_regions.hg38.interval_list
 wget -nc -v -P $DATA_PATH/genomics-public-data/references/broad/hg38/v0/ \
$GCP_PATH/genomics-public-data/references/hg38/v0/Homo_sapiens_assembly38.haplotype_database.txt
 wget -nc -v -P $DATA_PATH/genomics-public-data/references/broad/hg38/v0/ \
$GCP_PATH/genomics-public-data/references/hg38/v0/Homo_sapiens_assembly38.contam.UD
 wget -nc -v -P $DATA_PATH/genomics-public-data/references/broad/hg38/v0/ \
$GCP_PATH/genomics-public-data/references/hg38/v0/Homo_sapiens_assembly38.contam.mu
 wget -nc -v -P $DATA_PATH/genomics-public-data/references/broad/hg38/v0/ \
$GCP_PATH/genomics-public-data/references/hg38/v0/Homo_sapiens_assembly38.contam.bed
# Need to find following reference 
# wget -nc -v -P $DATA_PATH/genomics-public-data/references/broad/hg38/v0/ \
#$GCP_PATH/genomics-public-data/references/hg38/v0/hg38_wgs_scattered_calling_intervals.txt
# wget -nc -v -P $DATA_PATH/genomics-public-data/references/broad/hg38/v0/ \
#$GCP_PATH/genomics-public-data/references/hg38/v0/NA12878.hg38.reference.fingerprint.vcf

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

# Refresh WARP WDL 2.3.3
echo "Downloading WDL for Single Sample Workflow "
bash $BASEDIR/change_wdl.sh
echo "WDL downloaded and changed successfully"

sleep 1
source $BASEDIR/configure
limit=$NUM_WORKFLOW

echo Replicating 20k Dataset for 20k-Throughput-run
for i in $(seq $limit)
do
        cp -r $DATA_PATH/genomics-public-data $DATA_PATH/genomics-public-data$i
done

