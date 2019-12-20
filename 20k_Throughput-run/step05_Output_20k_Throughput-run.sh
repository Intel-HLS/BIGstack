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

curl localhost:8000/api/workflows/v1/query 2>/dev/null | json_pp>cromwell_stop

diff -urN cromwell-monitor/cromwell_start cromwell_stop > cromwell_diff
count=`cat cromwell_diff | grep  + | grep status | grep Running | wc -l`
finish=`cat cromwell_diff | grep + | grep status | grep Succeeded | wc -l`
failed=`cat cromwell_diff | grep + | grep status | grep Failed| wc -l`
echo $count running:  $finish finished: $failed failed
if [ $count -gt 0 ]
then
echo workflow still in progress
exit
fi

# add the find_times here

s=`grep start cromwell_diff | cut -d '"' -f 4 | sort | head -n 1`
e=`grep end cromwell_diff | cut -d '"' -f 4 | sort | tail -n 1`

#echo $s $e

s=`echo $s | tr 'T' ' ' | tr 'Z' '\n'`
e=`echo $e | tr 'T' ' ' | tr 'Z' '\n'`
s=`date -d "$s" +%s`
e=`date -d "$e" +%s`

sec=`expr $e - $s`
min=$(($sec / 60))
minsec=$(($sec % 60))

printf "Total Elapsed Time for $NUM_WORKFLOW workflows: $min minutes:%2d seconds \n " $minsec

########## Average elapse time taken for Mark Duplicates#############
sum=0
limit=$NUM_WORKFLOW

for i in `cat 20k_WF_ID/20k_WF_ID_* | cut -d '"' -f2`;
do

data=`grep "Elapsed time: " $GENOMICS_PATH/cromwell/cromwell-slurm-exec/PairedEndSingleSampleWorkflow/$i/call-MarkDuplicates/execution/stderr | cut -d ':' -f 4 | cut -d " " -f 2`

x=`echo $data | cut -d '.' -f 1`
y=`echo $data | cut -d '.' -f 2`
let "z= 10#$x*100 + 10#$y"

let "sum= 10#$sum + 10#$z"

done

let "avg = sum / $limit"
let "x = $avg / 100"
let "y = $avg % 100"
printf "Average Elapsed Time for Mark Duplicates: $x.%02d minutes\n" $y


