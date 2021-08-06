
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $BASEDIR

# sudo yum install -y R
# sudo yum install -y jq
# Create generic symlinks for tools e.g. :
# for tool in bwa samtools gatk; do export tool_version=`ls $GENOMICS_PATH/tools | grep ${tool}- | head -n1` && echo ${tool_version} && ln -sfn $GENOMICS_PATH/tools/$tool_version $GENOMICS_PATH/tools/$tool; done;

# Clean up
rm -rf $BASEDIR/[A-V]*.wdl
rm -rf $BASEDIR/warp.zip

# Download WGS release from WARP
bash $BASEDIR/download.sh

# Fix WDL
unzip -d $BASEDIR/ $BASEDIR/WholeGenomeGermlineSingleSample*.zip
# grep -n -E 'picard|docker|disk|preemp|VerifyBamID|gatk|gitc|usr' $BASEDIR/*.wdl > $BASEDIR/changes.txt

echo "Commenting variables"
#sed -i 's|Int disk_size|#Int disk_size|g' $BASEDIR/*.wdl
sed -i  's|Int pre|#Int pre|g' $BASEDIR/*.wdl
sed -i 's|Int agg_preemptible_|#Int agg_preemptible_|g'  $BASEDIR/*.wdl
sed -i 's|preemptible:|#preemptible:|g' $BASEDIR/*.wdl
sed -i 's|disks:|#disks:|g' $BASEDIR/*.wdl
sed -i 's| preemptible_tries =| #preemptible_tries =|g' $BASEDIR/*.wdl
sed -i 's|agg_preemptible_tries =|#agg_preemptible_tries =|g' $BASEDIR/*.wdl

echo "Changing tool_path"
sed -i 's|gatk --java|${tool_path}/gatk/gatk --java|g' $BASEDIR/*.wdl
sed -i 's|use_gatk3_haplotype_caller = true|use_gatk3_haplotype_caller = false|g' $BASEDIR/*.wdl
sed -i 's|samtools |${tool_path}/samtools/samtools |g' $BASEDIR/*.wdl
sed -i 's|seq_cache_populate\.pl |${tool_path}/samtools/misc/seq_cache_populate\.pl |g' $BASEDIR/*.wdl
sed -i 's|/usr/gitc/VerifyBamID|${tool_path}/VerifyBamID/bin/VerifyBamID |g' $BASEDIR/BamProcessing.wdl

sed -i 's|/usr/gitc/bwa|${tool_path}/bwa/bwa|g' $BASEDIR/*.wdl
sed -i 's|/usr/gitc/~{bwa_commandline}|${tool_path}/bwa/~{bwa_commandline}|g' $BASEDIR/*.wdl

echo "Changing picard"
sed -i  's|/usr/picard/picard.jar|${tool_path}/picard.jar|g' $BASEDIR/*.wdl
sed -i  's|/usr/gitc/picard-private.jar|${tool_path}/picard.jar|g' $BASEDIR/*.wdl
sed -i  's|/usr/gitc/picard.jar|${tool_path}/picard.jar|g' $BASEDIR/*.wdl

echo "Changing docker gatk"
sed -i 's|docker:|#docker:|g' $BASEDIR/*.wdl
sed -i  's|String gatk_docker|#String gatk_docker|g' $BASEDIR/*.wdl
sed -i 's|bootDiskSizeGb:|#bootDiskSizeGb:|g' $BASEDIR/*.wdl

# remove disk_size variable from germline
sed -i '283,288d' $BASEDIR/GermlineVariantDiscovery.wdl

echo "Resource changes"
bash  $BASEDIR/cpu.sh
echo """
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $BASEDIR """ > $BASEDIR/memory.sh
grep -n -E 'java |Xms' $BASEDIR/*.wdl | grep -v Xmx| grep -v java-option | awk -F':' '{print "sed -i \""$2"s|-Xms|-Xmx8192m -Xms|\" \t "$1  "\t#"$NF}' >>  $BASEDIR/memory.sh
grep -n -E 'java-options "' $BASEDIR/*.wdl | grep -v Xmx | awk -F':' '{print "sed -i \""$2"s|options \\\"|options \\\" -Xmx8192m |\" \t "$1  "\t#"$NF}' >>  $BASEDIR/memory.sh
echo """ sed -i 's#-Xms6000m#\"-Xms6000m -Xmx8192m \"#g' $BASEDIR/Qc.wdl 
""" >> $BASEDIR/memory.sh

echo "Resource changes"
chmod +x  $BASEDIR/memory.sh 
bash  $BASEDIR/memory.sh

grep -n -A 2 -B 2 -E 'Xms|java|cpu|memory' $BASEDIR/*.wdl > $BASEDIR/resources.txt

echo "Replace tool_path"
source $BASEDIR/configure
sed -i 's|\${tool_path}|'$GENOMICS_PATH'/tools|g' $BASEDIR/*.wdl 
sed -i '44i \    String tool_path = "'${GENOMICS_PATH}'/tools"'  $BASEDIR/WholeGenomeGermlineSingleSample_*.wdl 


echo " Create import WDLs zip"
zip -j  $BASEDIR/warp.zip $BASEDIR/*.wdl
rm -rf $BASEDIR/[A-V]*.wdl
mv $BASEDIR/WholeGenomeGermlineSingleSample_*.wdl $BASEDIR/WholeGenomeGermlineSingleSample.wdl

