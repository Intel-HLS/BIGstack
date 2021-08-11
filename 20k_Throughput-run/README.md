# 20k Single Sample Workflow
To submit, monitor, and receive output from these workflows, follow these steps:

Prerequisites
Genomics Tools	Version
WARP	v2.3.3
GATK	4.1.9.0
bwa	0.7.17
cromwell	57
samtools	1.9
picard	>= 2.20.0
VerifyBamID2
Please refer to WARP Requirement for more details.


## 1.	Clone the repository
To clone the repository, run these commands:

     git clone https://github.com/BIGstack.git
     
     cd 20k_Throughput-run
  
## 2.	Configure and setup environment variables
Edit the configure file to set up the various paths to work directories:GENOMICS_PATH, TOOLS_PATH, DATA_PATH and NUM_WORKFLOW and zip the wdls in to warp.zip

./configure

## 3.	Configure and the JSON files

./step01_Configure_20k_Throughput-run.sh

Modifies the Tool and Dataset paths in the json WholeGenomeGermlineSingleSample_20k.json file.

## 4.	Download datasets
This step will download the dataset to 'data' directory in the working directory.

./step02_Download_20k_Data_Throughput-run.sh

## 5.	Run the 20k Throughput workflow
Submit the workflow to the Cromwell workflow engine using this script: 

./step03_Cromwell_Run_20k_Throughput-run.sh.

After running this script, the HTTP response and workflow submission information are written to 20k_submission_response.txt in your home directory. Additionally, the workflow identifier for throughput run (for example: "id": "6ec0643c-1ea1-42bf-b60c-507cd1e3e96c"), is written to the file 20k_WF_ID.timestamp, which is used by steps 6 and 7.

## 6.	Monitor the workflow for Workflow status - Failed, Succeeded, Running
To monitor the 20k Single Sample workflow, execute:

./step04_Cromwell_Monitor_Single_Sample_20k_Workflow.sh.

## 7.	View 20k Single Sample Workflow Output
This will output the Elapse time and average Markduplicates elapse time.

./step05_Single_Sample_20k_Workflow_Output.sh.

# Troubleshooting

## Install dependencies for Step 3 and 4 :
 sudo yum install R -y
 sudo yum install jq -y
 Make sure python2 and python3 are installed and symlinks are created.
## Create generic symlinks for tools to latest/desired version - By default tool paths in wdl files uses generic symlinks :
 for tool in bwa samtools gatk;
 do 
   export tool_version=`ls $GENOMICS_PATH/tools | grep ${tool}- | head -n1` && echo ${tool_version} && ln -sfn $GENOMICS_PATH/tools/$tool_version $GENOMICS_PATH/tools/$tool; 
 done;
