#/bin/bash
export http_proxy=
export https_proxy=
USERNAME="bob"
PASSWORD="bob"
FRONTEND_HOST=$HOSTNAME
#FRONTEND_PORT=$(lsof -Pan -p $(ps waux | grep frontend | grep "java -jar" | awk '{print $2}') -i | grep -i listen | awk '{print $9}' | grep -E -o "[0-9]{4}")
#Contact your admin to obtain Frontend port - 8080 by default

curl -vXGET -u $USERNAME:$PASSWORD $FRONTEND_HOST:8080/api/v1/workflows/$(cat 20k_WF_ID.txt)/metadata
