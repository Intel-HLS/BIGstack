# 20k Single Sample Workflow
To submit, monitor, and receive output from these workflows, follow these steps:

## 1.	Clone the repository
To clone the repository, run these commands:

     git clone https://github.com/BIGstack.git
     
     cd 20k_Throughput-run
  
## 2.	Configure and setup environment variables
Edit the configure file to set up the various paths to work directories:GENOMICS_PATH, TOOLS_PATH, DATA_PATH and NUM_WORKFLOW

./configure

## 3.	Configure and replicate the JSON files

./step01_Configure_20k_Throughput-run.sh

In the WDL file, modify https://github.com/BIGstack/blob/master/20k_Throughput-run/PairedSingleSampleWf_noqc_nocram_optimized.wdl.20k to point to the path where the input files for this test datasets were downloaded to and the tool paths.

## 4.	Download and replicate genomic datasets
This step will download the dataset and replicate it for the number of workflows specified in the configure script.

./step02_Download_20k_Data_Throughput-run.sh

## 5.	Run the 20k Throughput workflow
You can submit the workflow to the Cromwell workflow engine using this script: 

./step03_Cromwell_Run_20k_Throughput-run.sh.

After running this script, the HTTP response and workflow submission information are written to 20k_submission_response.txt in your home directory. Additionally, the workflow identifier for throughput run (for example: "id": "6ec0643c-1ea1-42bf-b60c-507cd1e3e96c"), is written to the file 20k_WF_ID.timestamp, which is used by steps 6 and 7.

## 6.	Monitor the workflow for Workflow status - Failed, Succeeded, Running
To monitor the 20k Single Sample workflow, execute:

./step04_Cromwell_Monitor_Single_Sample_20k_Workflow.sh.

## 7.	View 20k Single Sample Workflow Output
To view the output of this tutorial 20k Single Sample workflow, execute:

./step05_Single_Sample_20k_Workflow_Output.sh.

