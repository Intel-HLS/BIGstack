
# clean up
rm -rf Whole*
rm -rf *.wdl
rm -rf warp.zip

#download WGS release from WARP
bash download.sh

# Fix WDL
unzip WholeGenomeGermlineSingleSample_develop.zip
grep -n -E 'picard|docker|disk|preemp|VerifyBamID|gatk|gitc|usr' *.wdl > changes.txt

echo "Changing picard"
sed -i  's|/usr/picard/picard.jar|${tool_path}/picard.jar|g' *.wdl
sed -i  's|/usr/gitc/picard-private.jar|${tool_path}/picard.jar|g' *.wdl
sed -i  's|/usr/gitc/picard.jar|${tool_path}/picard.jar|g' *.wdl

echo "Changing docker gatk"
sed -i 's|docker:|#docker:|g' *.wdl
sed -i  's|String gatk_docker|#String gatk_docker|g' *.wdl
sed -i 's|bootDiskSizeGb:|#bootDiskSizeGb:|g' *.wdl

echo "Commenting variables"
#sed -i 's|Int disk_size|#Int disk_size|g' *.wdl
sed -i  's|Int pre|#Int pre|g' *.wdl
sed -i 's|Int agg_preemptible_|#Int agg_preemptible_|g'  *.wdl
sed -i 's|preemptible:|#preemptible:|g' *.wdl
sed -i 's|disks:|#disks:|g' *.wdl
sed -i 's| preemptible_tries =| #preemptible_tries =|g' *.wdl
sed -i 's|agg_preemptible_tries =|#agg_preemptible_tries =|g' *.wdl

echo "Changing tool_path"
sed -i 's|gatk --java|${tool_path}/gatk/gatk --java|g' *.wdl
sed -i 's|use_gatk3_haplotype_caller = true|use_gatk3_haplotype_caller = false|g' *.wdl
sed -i 's|samtools |${tool_path}/samtools |g' *.wdl

sed -i 's|/usr/gitc/VerifyBamID|${tool_path}/VerifyBamID/bin/VerifyBamID |g' BamProcessing.wdl
sudo yum install -y R

export num_freemix=`grep -n FREEMIX BamProcessing.wdl | grep print | cut -d ':' -f1`
sed -i $num_freemix'd'  BamProcessing.wdl
sed -i $num_freemix'i print(float(row["FREEMIX(alpha)"])/~{contamination_underestimation_factor})'  BamProcessing.wdl

sed -i 's|/usr/gitc/bwa|${tool_path}/bwa/bwa|g' *.wdl
sed -i 's|/usr/gitc/~{bwa_commandline}|${tool_path}/bwa/~{bwa_commandline}|g' *.wdl

# Troubleshooting BWA
#sed -i '50d' Alignment.wdl      
#sed -i '50i      BWA_VERSION=$(/fastdata/01/genomics/tools/bwa/bwa 2>&1| \\ ' Alignment.wdl

sed -i 's|\${tool_path}|'$GENOMICS_PATH'/tools|g' *.wdl

# remove disk_size variable from germline
sed -i '283,288d' GermlineVariantDiscovery.wdl

zip warp.zip *.wdl
rm -rf [A-V]*.wdl
mv WholeGenomeGermlineSingleSample_develop.wdl WholeGenomeGermlineSingleSample.wdl
sed -i '44i         String tool_path = "'${GENOMICS_PATH}'/tools"'  WholeGenomeGermlineSingleSample.wdl

#Test pipeline

curl -vXPOST http://127.0.0.1:8000/api/workflows/v1 -F workflowSource=@WholeGenomeGermlineSingleSample.wdl -F workflowInputs=@20k_WholeGenomeGermlineSingleSample.json -F workflowDependencies=@warp.zip

sleep 10 

curl -vXGET localhost:8000/api/workflows/v1/query?status=Running | json_pp | jq .results | jq '.[] | (.id +" | " + .status + " | " + .start + " | "+ .submission + "|" + .rootWorkflowId )'

ls -tr /fastdata/01/genomics/cromwell/cromwell-slurm-exec/WholeGenomeGermlineSingleSample/ | tail -n1 | xargs -I {} -n1 grep {} $GENOMICS_PATH/cromwell/cromwell.log


echo " Check tail -f $GENOMICS_PATH/cromwell/cromwell.log "










