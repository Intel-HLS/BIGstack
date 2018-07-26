#/bin/bash
export http_proxy=
export https_proxy=
CROMWELL_HOST=$HOSTNAME
#CROMWELL_PORT=$(lsof -Pan -p $(ps waux | grep cromwell | grep "java -jar" \ 
#| awk '{print $2}') -i | grep -i listen | awk '{print $9}' | grep -E -o "[0-9]{4}")
#Contact your admin to obtain Cromwell port - 8000 by default

curl -vXGET $CROMWELL_HOST:8000/api/workflows/v1/$(cat 20k_WF_ID.txt)/status
