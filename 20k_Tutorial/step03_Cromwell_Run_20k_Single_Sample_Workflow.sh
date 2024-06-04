#! /bin/bash
export http_proxy=
export https_proxy=
CROMWELL_HOST=$HOSTNAME
#CROMWELL_PORT=$(lsof -Pan -p $(ps waux | grep cromwell | grep "java -jar" | awk '{print $2}') -i | grep -i listen | awk '{print $9}' | grep -E -o "[0-9]{4}")
#Cromwell port is 8000 by default. Contact your admin if port is different

curl -vXPOST http://$CROMWELL_HOST:8000/api/workflows/v1 -F workflowSource=@PairedSingleSampleWf_noqc_nocram_optimized.wdl \
-F workflowInputs=@16T_PairedSingleSampleWf_optimized.inputs.20k.json > 20k_submission_response.txt

cat 20k_submission_response.txt | grep -o -E "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" \
> 20k_WF_ID.txt
