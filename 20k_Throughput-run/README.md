# 20k Single Sample Workflow
 To submit, monitor, and receive output from these workflows, follow these steps:


## Prerequisites

 | Genomics Tools | Version |
 | :---: | --- |
 | **WARP** | 	v2.3.3 |
 | **GATK** | 	4.1.9.0 |
 | **bwa** | 	0.7.17 |
 | **cromwell** | 	57 |
 | **samtools** | 	1.9 |
 | **picard** | 	>= 2.20.0  |
 | **VerifyBamID2**  | commit `c1cba76e979904eb69c31520a0d7f5be63c72253` |
 
   Please refer to [WARP Requirement](https://broadinstitute.github.io/warp/docs/Pipelines/Whole_Genome_Germline_Single_Sample_Pipeline/README#software-version-requirements) for more details.

## Run Workflow

### 1.   Clone the repository
   To clone the repository, run these commands:

   ```
     git clone https://github.com/Intel-HLS/BIGstack.git
     cd 20k_Throughput-run
   ```

### 2.   Configure and setup environment variables
   Edit the configure file to set up the various paths to work directories:

    vim configure

    GENOMICS_PATH= # Set up path
    TOOLS_PATH=$GENOMICS_PATH/tools # path to tools
    DATA_PATH=$GENOMICS_PATH/data # path to genomics public data
    NUM_WORKFLOW= # Number of 20k Parallel Workflow

### 3.   Configure and replicate the JSON files

    ./step01_Configure_20k_Throughput-run.sh
    
   The JSON folder is created and contains modified configuration files [WholeGenomeGermlineSingleSample_20k.json](WholeGenomeGermlineSingleSample_20k.json).

### 4.   Download and replicate genomic datasets
   This step will download the dataset and replicate it for the number of workflows specified in the configure script.

    ./step02_Download_20k_Data_Throughput-run.sh
    
  The `warp.zip` and [WholeGenomeGermlineSingleSample.wdl](WholeGenomeGermlineSingleSample.wdl) WDL are modified using [change_wdl.sh](change_wdl.sh) to point to the configured tools path and input files for the workflow.

### 5.   Run the 20k Throughput workflow
   You can submit the workflow to the Cromwell workflow engine using this script:

    ./step03_Cromwell_Run_20k_Throughput-run.sh

After running this script, the HTTP response and workflow submission information are written to `20k_submission_response.txt` in your working directory. Additionally, the workflow identifier for throughput run (for example: `"id": "6ec0643c-1ea1-42bf-b60c-507cd1e3e96c"`), is written to the files under `20k_WF_ID*` folder, which are used by steps 6 and 7.
 
### 6.   Monitor the workflow for Workflow status - Failed, Succeeded, Running
   To monitor the 20k Single Sample workflow, execute:

    ./step04_Cromwell_Monitor_20k_Throughput-run.sh

### 7.   View 20k Single Sample Workflow Output
   To view the output of this tutorial 20k Single Sample workflow, execute:

    ./step05_Output_20k_Throughput-run.sh

## Troubleshooting   
   #### Install dependencies for Step 3 and 4 : 
     sudo yum install R -y
     sudo yum install jq -y
     
   #### Create generic symlinks for tools to latest/desired version for change_wdl.sh :
     for tool in bwa samtools gatk;
     do 
       export tool_version=`ls $GENOMICS_PATH/tools | grep ${tool}- | head -n1` && echo ${tool_version} && ln -sfn $GENOMICS_PATH/tools/$tool_version $GENOMICS_PATH/tools/$tool; 
     done;
   
