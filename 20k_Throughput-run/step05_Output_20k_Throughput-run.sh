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

start_date=`cat cromwell_start_date`
count=`curl -sGET "$CROMWELL_HOST:8000/api/workflows/v1/query?start=$start_date&status=Running&includeSubworkflows=false" | jq '.totalResultsCount'`
finish=`curl -sGET "$CROMWELL_HOST:8000/api/workflows/v1/query?start=$start_date&status=Succeeded&includeSubworkflows=false" | jq '.totalResultsCount'`
failed=`curl -sGET "$CROMWELL_HOST:8000/api/workflows/v1/query?start=$start_date&status=Failed&includeSubworkflows=false" | jq '.totalResultsCount'`
echo running: $count  finished: $finish  failed:  $failed
#grep suceeded runs to cromwell-save to calculate elapse time:

sh step04_Cromwell_Monitor_20k_Throughput-run.sh | grep WholeGenomeGermlineSingleSample | sort>cromwell-save
s=`cat cromwell-save | cut -d '|' -f4 | sort | head -1`
e=`cat cromwell-save | cut -d '|' -f5 | sort | tail -n 1 `

if [ $count -gt 0 ]
then
echo workflow still in progress
exit
fi

#echo $s $e

s=`echo $s | tr 'T' ' ' | tr 'Z' '\n'`
e=`echo $e | tr 'T' ' ' | tr 'Z' '\n'`
#echo $s $e

s=`date -d "$s" +%s`
e=`date -d "$e" +%s`

sec=`expr $e - $s`
min=$(($sec / 60))
minsec=$(($sec % 60))

printf "Total Elapsed Time for $NUM_WORKFLOW workflows: $min minutes:%2d seconds \n " $minsec

########## Average elapse time taken for Mark Duplicates#############
sum=0
limit=$NUM_WORKFLOW

for i in `cat 20k_WF_ID/20k_WF_ID_*`;
do

data=`grep "Elapsed time: " $GENOMICS_PATH/cromwell/cromwell-slurm-exec/WholeGenomeGermlineSingleSample/$i/call-*/*/*/call-MarkDuplicates/execution/stderr | cut -d ':' -f 4 | cut -d " " -f 2`

x=`echo $data | cut -d '.' -f 1`
y=`echo $data | cut -d '.' -f 2`
let "z= 10#$x*100 + 10#$y"

let "sum= 10#$sum + 10#$z"

done

let "avg = sum / $limit"
let "x = $avg / 100"
let "y = $avg % 100"
printf "Average Elapsed Time for Mark Duplicates: $x.%02d minutes\n" $y


