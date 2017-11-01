#/bin/bash
export http_proxy=
export https_proxy=
USERNAME="bob"
PASSWORD="bob"
FRONTEND_HOST=$HOSTNAME
#PID=$(ps waux | grep frontend | grep jar | awk '{print $2}')
#FRONTEND_PORT=$(sudo lsof -Pan -p $PID -i | grep -i listen | awk '{print $9}' | grep -E -o "[0-9]{4}")
#Frontend port is 8080 by default - Contact admin if port is different

curl -vXPOST -u $USERNAME:$PASSWORD http://$FRONTEND_HOST:8080/api/v1/workflowcollections \
-F wdlSource=@PairedSingleSampleWf_noqc_nocram_optimized.wdl.wdl \
-F workflowInputs=@PairedSingleSampleWf_noqc_nocram_optimized.inputs.20k.json > 20k_submission_response.txt;
cat 20k_submission_response.txt | grep -o -E "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" \
| tail -1 > 20k_WF_ID.txt
#Second id is actual wf Id - first one is transaction id - ignore
