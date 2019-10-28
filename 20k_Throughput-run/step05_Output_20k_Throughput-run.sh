#! /bin/bash

source configure

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
echo $s $e total seconds: $sec minunts: $min

########## Average elapse time taken for Mark Duplicates#############
sum=0
limit=$NUM_WORKFLOW

for i in `cat 20k_WF_ID/20k_WF_ID_* | cut -d '"' -f2`;
do

echo $i
data=`grep "Elapsed time: " /mnt/lustre/genomics/cromwell/cromwell-slurm-exec/PairedEndSingleSampleWorkflow/$i/call-MarkDuplicates/execution/stderr | cut -d ':' -f 4 | cut -d " " -f 2`
echo Elapsed time : $data minutes

x=`echo $data | cut -d '.' -f 1`
y=`echo $data | cut -d '.' -f 2`
let "z= $x*100 + $y"

let "sum= $sum + $z"

done

let "avg = sum / $limit"
let "x = $avg / 100"
let "y = $avg % 100"
echo Average Elapsed Time for $NUM_WORKFLOW workflows : $x.$y minutes

