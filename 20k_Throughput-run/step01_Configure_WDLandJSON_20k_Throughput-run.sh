#! /bin/bash

###########Editing JSON file#############
source configure

datapath=${DATA_PATH}
toolspath=${TOOLS_PATH}


mkdir$BASEDIR/WDL
mkdir $BASEDIR/JSON

#edit the path to dataset
newdatapath=${GENOMICS_PATH}/data
newtoolspath=${TOOLS_PATH}/tools
sed -i "s%$datapath%$newdatapath%g" JSON/PairedSingleSampleWf_optimized.inputs.20k.json
sed -i "s%$toolspath%$newtoolspath%g" JSON/PairedSingleSampleWf_optimized.inputs.20k.json
limit=$NUM_WORKFLOW
for i in $(seq $limit)
do

   cp $BASEDIR/PairedSingleSampleWf_optimized.inputs.20k.json $BASEDIR/JSON/PairedSingleSampleWf_optimized.inputs${i}.20k.json
done


############Editing WDL file##################
#add the tool versions

cp $BASEDIR/PairedSingleSampleWf_noqc_nocram_optimized.wdl.20k $BASEDIR/JSON/PairedSingleSampleWf_noqc_nocram_optimized.wdl.20k
