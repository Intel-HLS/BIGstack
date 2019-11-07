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

source ./configure

WDL=PairedSingleSampleWf_noqc_nocram_optimized.wdl.20k
JSON=$BASEDIR/JSON/PairedSingleSampleWf_optimized.inputs

limit=$NUM_WORKFLOW

export DATE_WITH_TIME=`date "+%Y%m%d:%H-%M-%S"`
mkdir "20k_WF_ID-"$DATE_WITH_TIME""
mkdir "cromwell-status-"$DATE_WITH_TIME""
#remove the temporarary diriectories from previous runs.
rm -rf cromwell-monitor
rm -rf 20k_WF_ID
#creating new temporary directories for monitoring and output results
mkdir cromwell-monitor 
mkdir 20k_WF_ID

curl localhost:8000/api/workflows/v1/query 2>/dev/null | json_pp>"cromwell-status-"$DATE_WITH_TIME""/cromwell_start
cp "cromwell-status-"$DATE_WITH_TIME""/cromwell_start cromwell-monitor


echo Start time is `date`  : `date +"%H:%M:%S"`


for i in $(seq $limit)
do
        echo $i
        curl -vXPOST http://$CROMWELL_HOST:8000/api/workflows/v1 -F workflowSource=@${WDL} -F workflowInputs=@${JSON}${i}.20k.json > 20k_submission_response.txt
	cat 20k_submission_response.txt |  cut -d '"' -f4 >"20k_WF_ID-"$DATE_WITH_TIME""/20k_WF_ID_${i}.txt
sleep 5

cp "20k_WF_ID-"$DATE_WITH_TIME""/20k_WF_ID_* 20k_WF_ID
done


