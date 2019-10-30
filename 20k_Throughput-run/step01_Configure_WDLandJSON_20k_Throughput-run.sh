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
#

###########Editing JSON file#############
source configure

datapath=${DATA_PATH}
toolspath=${TOOLS_PATH}


mkdir -p  $BASEDIR/WDL
mkdir -p  $BASEDIR/JSON

#edit the path to dataset
cp $BASEDIR/PairedSingleSampleWf_optimized.inputs.20k.json $BASEDIR/JSON/PairedSingleSampleWf_optimized.inputs.20k.json
newdatapath=${GENOMICS_PATH}/data
newtoolspath=${TOOLS_PATH}/tools
sed -i "s%$datapath%$newdatapath%g" $BASEDIR/JSON/PairedSingleSampleWf_optimized.inputs.20k.json
sed -i "s%$toolspath%$newtoolspath%g" $BASEDIR/JSON/PairedSingleSampleWf_optimized.inputs.20k.json
limit=$NUM_WORKFLOW

for i in $(seq $limit)
do

   cp $BASEDIR/JSON/PairedSingleSampleWf_optimized.inputs.20k.json $BASEDIR/JSON/PairedSingleSampleWf_optimized.inputs${i}.20k.json
done


############Editing WDL file##################
#user may either edit the tool versions in the WDL file or create symlinks to each tool and add the symlink to the WDL

cp $BASEDIR/PairedSingleSampleWf_noqc_nocram_optimized.wdl.20k $BASEDIR/WDL/PairedSingleSampleWf_noqc_nocram_optimized.wdl.20k
