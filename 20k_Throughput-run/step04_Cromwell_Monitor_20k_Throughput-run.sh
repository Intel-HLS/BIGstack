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

curl -s $CROMWELL_HOST:8000/api/workflows/v1/query 2>/dev/null | json_pp>cromwell_stop

start_date=`cat cromwell_start_date`
count=`curl -sGET "$CROMWELL_HOST:8000/api/workflows/v1/query?start=$start_date&status=Running&includeSubworkflows=false" | jq '.totalResultsCount'`
finish=`curl -sGET "$CROMWELL_HOST:8000/api/workflows/v1/query?start=$start_date&status=Succeeded&includeSubworkflows=false" | jq '.totalResultsCount'`
failed=`curl -sGET "$CROMWELL_HOST:8000/api/workflows/v1/query?start=$start_date&status=Failed&includeSubworkflows=false" | jq '.totalResultsCount'`
echo running: $count  finished: $finish  failed:  $failed

echo "-----------------------------"
echo ' 	          workflow_id         |  status   |	     start           |	  	 end            |  	    name 	| 	parent_workflow_id' 
for WFID in `cat $BASEDIR/20k_WF_ID/*`; do 
	echo "-----------------------------"
	curl -sXGET $CROMWELL_HOST:8000/api/workflows/v1/query?status={Submitted,Running,Aborting,Failed,Succeeded,Aborted} | jq ' .results | [.|= sort_by(.start)] | .[] | .[] | ( .id + " | "  + .status + " | " + .start + " | "+ .end +" | " + .name + " | " + .rootWorkflowId )' | grep $WFID  | tr '"' '|'
done;
