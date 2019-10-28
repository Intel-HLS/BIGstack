#/bin/bash

source configure

curl localhost:8000/api/workflows/v1/query 2>/dev/null | json_pp>cromwell_stop

diff -urN cromwell-monitor/cromwell_start cromwell_stop > cromwell_diff
count=`cat cromwell_diff | grep  + | grep status | grep Running | wc -l`
finish=`cat cromwell_diff | grep + | grep status | grep Succeeded | wc -l`
failed=`cat cromwell_diff | grep + | grep status | grep Failed| wc -l`
echo running: $count  finished: $finish  failed:  $failed

