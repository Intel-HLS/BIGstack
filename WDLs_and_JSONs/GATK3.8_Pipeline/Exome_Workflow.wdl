## Copyright Broad Institute, 2017
## 
## This WDL pipeline implements data pre-processing and initial variant calling (GVCF 
## generation) according to the GATK Best Practices (June 2016) for germline SNP and 
## Indel discovery in human sequencing data. Example JSONs are provided for the WGS 
## use case but the workflow can be applied to Exomes and Targeted Panels by swapping
## out the intervals files and specifying a non-zero value for interval padding (we
## recommend 100).
##
## Requirements/expectations :
## - Human pair-end sequencing data in unmapped BAM (uBAM) format
## - One or more read groups, one per uBAM file, all belonging to a single sample (SM)
## - Input uBAM files must additionally comply with the following requirements:
## - - filenames all have the same suffix (we use ".unmapped.bam")
## - - files must pass validation by ValidateSamFile 
## - - reads are provided in query-sorted order
## - - all reads must have an RG tag
## - GVCF output names must end in ".g.vcf.gz"
##
## Runtime parameters are optimized for Broad's Google Cloud Platform implementation. 
## For program versions, see docker containers. 
##
## LICENSING : 
## This script is released under the WDL source code license (BSD-3) (see LICENSE in 
## https://github.com/broadinstitute/wdl). Note however that the programs it calls may 
## be subject to different licenses. Users are responsible for checking that they are
## authorized to run all programs before running this script. Please see the docker 
## page at https://hub.docker.com/r/broadinstitute/genomes-in-the-cloud/ for detailed
## licensing information pertaining to the included programs.

# TASK DEFINITIONS

# Get version of BWA
task GetBwaVersion {
  String memory 
  Int cpu
  String tool_path
  command {
    # Not setting "set -o pipefail" here because /bwa has a rc=1 and we don't want to allow rc=1 to succeed 
    # because the sed may also fail with that error and that is something we actually want to fail on.
    ${tool_path}/bwa 2>&1 | \
    grep -e '^Version' | \
    sed 's/Version: //'
  }
  runtime {
    memory: memory
    cpu: cpu
  }
  output {
    String version = read_string(stdout())
  }
}

# Read unmapped BAM, convert on-the-fly to FASTQ and stream to BWA MEM for alignment
task SamToFastqAndBwaMem {
  File input_bam
  String bwa_commandline
  String output_bam_basename
  File ref_fasta
  File ref_fasta_index
  File ref_dict
  Int bwa_threads
  Int samtools_threads
  String java_heap_memory
  String tool_path
  
  # This is the .alt file from bwa-kit (https://github.com/lh3/bwa/tree/master/bwakit), 
  # listing the reference contigs that are "alternative". Leave blank in JSON for legacy 
  # references such as b37 and hg19.
  File? ref_alt

  File ref_amb
  File ref_ann
  File ref_bwt
  File ref_pac
  File ref_sa

  String memory
  Int cpu 
  
  String tmp_directory

  command <<<
    set -o pipefail
    set -e

    # set the bash variable needed for the command-line
    bash_ref_fasta=${ref_fasta}
    bwa_threads=${bwa_threads}

  	java -Djava.io.tmpdir=${tmp_directory} -Xmx${java_heap_memory} -jar ${tool_path}/picard.jar \
    	SamToFastq \
    	INPUT=${input_bam} \
    	FASTQ=/dev/stdout \
    	INTERLEAVE=true \
    	NON_PF=true | \
  	${tool_path}/${bwa_commandline} /dev/stdin -  2> >(tee ${output_bam_basename}.bwa.stderr.log >&2) | \
  	${tool_path}/samtools view -1 -@ ${samtools_threads} - > ${output_bam_basename}.bam

  >>>
  runtime {
    memory: memory
    cpu: cpu
  }
  output {
    File output_bam = "${output_bam_basename}.bam"
    File bwa_stderr_log = "${output_bam_basename}.bwa.stderr.log"
  }
}

# Merge original input uBAM file with BWA-aligned BAM file
task MergeBamAlignment {
  File unmapped_bam
  String bwa_commandline
  String bwa_version
  File aligned_bam
  String output_bam_basename
  File ref_fasta
  File ref_fasta_index
  File ref_dict
  Int bwa_threads
  String java_heap_memory
  String memory
  Int cpu
  String tool_path
  String tmp_directory
  
  command {
    # set the bash variable needed for the command-line
    bash_ref_fasta=${ref_fasta}
    bwa_threads=${bwa_threads}
    java -Djava.io.tmpdir=${tmp_directory} -Xmx${java_heap_memory} -jar ${tool_path}/picard.jar \
      MergeBamAlignment \
      VALIDATION_STRINGENCY=SILENT \
      EXPECTED_ORIENTATIONS=FR \
      ATTRIBUTES_TO_RETAIN=X0 \
      ALIGNED_BAM=${aligned_bam} \
      UNMAPPED_BAM=${unmapped_bam} \
      OUTPUT=${output_bam_basename}.bam \
      REFERENCE_SEQUENCE=${ref_fasta} \
      PAIRED_RUN=true \
      SORT_ORDER="unsorted" \
      IS_BISULFITE_SEQUENCE=false \
      ALIGNED_READS_ONLY=false \
      CLIP_ADAPTERS=false \
      MAX_RECORDS_IN_RAM=2000000 \
      ADD_MATE_CIGAR=true \
      MAX_INSERTIONS_OR_DELETIONS=-1 \
      PRIMARY_ALIGNMENT_STRATEGY=MostDistant \
      PROGRAM_RECORD_ID="bwamem" \
      PROGRAM_GROUP_VERSION="${bwa_version}" \
      PROGRAM_GROUP_COMMAND_LINE="${bwa_commandline}" \
      PROGRAM_GROUP_NAME="bwamem" \
      UNMAPPED_READ_STRATEGY=COPY_TO_TAG \
      ALIGNER_PROPER_PAIR_FLAGS=true \
      UNMAP_CONTAMINANT_READS=true
  }
  runtime {
    memory: memory
    cpu: cpu
  }
  output {
    File output_bam = "${output_bam_basename}.bam"
  }
}

# Sort BAM file by coordinate order and fix tag values for NM and UQ
task SortAndFixTags {
  File input_bam
  String output_bam_basename
  File ref_dict
  File ref_fasta
  File ref_fasta_index
  String sort_java_heap_memory
  String fix_tags_java_heap_memory
  String memory
  Int cpu
  String tool_path
  String tmp_directory
  
  command {
    set -o pipefail

    java -Djava.io.tmpdir=${tmp_directory} -Xmx${sort_java_heap_memory} -jar ${tool_path}/picard.jar \
    SortSam \
    INPUT=${input_bam} \
    OUTPUT=/dev/stdout \
    SORT_ORDER="coordinate" \
    CREATE_INDEX=false \
    CREATE_MD5_FILE=false | \
    java -Djava.io.tmpdir=${tmp_directory} -Xmx${fix_tags_java_heap_memory} -jar ${tool_path}/picard.jar \
    SetNmAndUqTags \
    INPUT=/dev/stdin \
    OUTPUT=${output_bam_basename}.bam \
    CREATE_INDEX=true \
    CREATE_MD5_FILE=true \
    REFERENCE_SEQUENCE=${ref_fasta}
  }
  runtime {
    memory: memory
    cpu: cpu
  }
  output {
    File output_bam = "${output_bam_basename}.bam"
    File output_bam_index = "${output_bam_basename}.bai"
    File output_bam_md5 = "${output_bam_basename}.bam.md5"
  }
}

# Mark duplicate reads to avoid counting non-independent observations
task MarkDuplicates {
  Array[File] input_bams
  String output_bam_basename
  String metrics_filename
  String java_heap_memory
  String memory
  Int cpu
  String tool_path 
  String tmp_directory
 
 # Task is assuming query-sorted input so that the Secondary and Supplementary reads get marked correctly.
 # This works because the output of BWA is query-grouped and therefore, so is the output of MergeBamAlignment.
 # While query-grouped isn't actually query-sorted, it's good enough for MarkDuplicates with ASSUME_SORT_ORDER="queryname"
  command {
    java -Djava.io.tmpdir=${tmp_directory} -Xmx${java_heap_memory} -jar ${tool_path}/picard.jar \
      MarkDuplicates \
      INPUT=${sep=' INPUT=' input_bams} \
      OUTPUT=${output_bam_basename}.bam \
      METRICS_FILE=${metrics_filename} \
      VALIDATION_STRINGENCY=SILENT \
      OPTICAL_DUPLICATE_PIXEL_DISTANCE=2500 \
      ASSUME_SORT_ORDER="queryname"
      CREATE_MD5_FILE=true
  }
  runtime {
    memory: memory
    cpu: cpu
  }
  output {
    File output_bam = "${output_bam_basename}.bam"
    File duplicate_metrics = "${metrics_filename}"
  }
}

# Generate sets of intervals for scatter-gathering over chromosomes
task CreateSequenceGroupingTSV {
  File ref_dict
  String memory
  Int cpu

  # Use python to create the Sequencing Groupings used for BQSR and PrintReads Scatter. 
  # It outputs to stdout where it is parsed into a wdl Array[Array[String]]
  # e.g. [["1"], ["2"], ["3", "4"], ["5"], ["6", "7", "8"]]
  command <<<
    python <<CODE
    with open("${ref_dict}", "r") as ref_dict_file:
        sequence_tuple_list = []
        longest_sequence = 0
        for line in ref_dict_file:
            if line.startswith("@SQ"):
                line_split = line.split("\t")
                # (Sequence_Name, Sequence_Length)
                sequence_tuple_list.append((line_split[1].split("SN:")[1], int(line_split[2].split("LN:")[1])))
        longest_sequence = sorted(sequence_tuple_list, key=lambda x: x[1], reverse=True)[0][1]
    # We are adding this to the intervals because hg38 has contigs named with embedded colons (:) and a bug in 
    # some versions of GATK strips off the last element after a colon, so we add this as a sacrificial element.
    hg38_protection_tag = ":1+"
    # initialize the tsv string with the first sequence
    tsv_string = sequence_tuple_list[0][0] + hg38_protection_tag
    temp_size = sequence_tuple_list[0][1]
    for sequence_tuple in sequence_tuple_list[1:]:
        if temp_size + sequence_tuple[1] <= longest_sequence:
            temp_size += sequence_tuple[1]
            tsv_string += "\t" + sequence_tuple[0] + hg38_protection_tag
        else:
            tsv_string += "\n" + sequence_tuple[0] + hg38_protection_tag
            temp_size = sequence_tuple[1]
    # add the unmapped sequences as a separate line to ensure that they are recalibrated as well
    with open("sequence_grouping.txt","w") as tsv_file:
      tsv_file.write(tsv_string)
      tsv_file.close()

    tsv_string += '\n' + "unmapped"

    with open("sequence_grouping_with_unmapped.txt","w") as tsv_file_with_unmapped:
      tsv_file_with_unmapped.write(tsv_string)
      tsv_file_with_unmapped.close()
    CODE
  >>>
  runtime {
    memory: memory
    cpu: cpu
  }
  output {
    Array[Array[String]] sequence_grouping = read_tsv("sequence_grouping.txt")
    Array[Array[String]] sequence_grouping_with_unmapped = read_tsv("sequence_grouping_with_unmapped.txt")
  }
}

# Generate Base Quality Score Recalibration (BQSR) model
task BaseRecalibrator {
  File input_bam
  File input_bam_index
  String recalibration_report_filename
  Array[String] sequence_group_interval
  File dbSNP_vcf
  File dbSNP_vcf_index
  Array[File] known_indels_sites_VCFs
  Array[File] known_indels_sites_indices
  File ref_dict
  File ref_fasta
  File ref_fasta_index
  String gatk_gkl_compression_level
  String memory
  Int cpu 
  String java_heap_memory
  String tmp_directory
  String tool_path
  
  command { // 
    java -Djava.io.tmpdir=${tmp_directory} -Xmx${java_heap_memory} \
      -jar ${tool_path}/GATK38.jar \
      -T BaseRecalibrator \
      -R ${ref_fasta} \
      -I ${input_bam} \
      --useOriginalQualities \
      --bam_compression ${gatk_gkl_compression_level} \
      -o ${recalibration_report_filename} \
      -knownSites ${dbSNP_vcf} \
      -knownSites ${sep=" -knownSites " known_indels_sites_VCFs} \
      -L ${sep=" -L " sequence_group_interval}
  }
  runtime {
    memory: memory
    cpu: cpu
  }
  output {
    File recalibration_report = "${recalibration_report_filename}"
  }
}

# Combine multiple recalibration tables from scattered BaseRecalibrator runs
# Note that when run from GATK 3.x the tool is not a walker and is invoked differently.
task GatherBqsrReports {
  Array[File] input_bqsr_reports
  String output_report_filename
  String memory
  Int cpu
  String java_heap_memory
  String tmp_directory
  String tool_path
  
  command {
    java -Djava.io.tmpdir=${tmp_directory} -Xmx${java_heap_memory} \
      -cp ${tool_path}/GATK38.jar org.broadinstitute.gatk.tools.GatherBqsrReports \
      I= ${sep=' I= ' input_bqsr_reports} \
      O= ${output_report_filename} 
    }
  runtime {
    memory: memory
    cpu: cpu
  }
  output {
    File output_bqsr_report = "${output_report_filename}"
  }
}

# Apply Base Quality Score Recalibration (BQSR) model
task ApplyBQSR {
  File input_bam
  File input_bam_index
  String output_bam_basename
  File recalibration_report
  Array[String] sequence_group_interval
  File ref_dict
  File ref_fasta
  File ref_fasta_index
  String gatk_gkl_compression_level
  String memory
  Int cpu
  String java_heap_memory
  String tmp_directory
  String tool_path
  
  command {  
    java -Djava.io.tmpdir=${tmp_directory} -Xmx${java_heap_memory} \
      -jar ${tool_path}/GATK38.jar \
      -T PrintReads \
      -R ${ref_fasta} \
      -I ${input_bam} \
      --useOriginalQualities \
      -o ${output_bam_basename}.bam \
      -BQSR ${recalibration_report} \
      -SQQ 10 -SQQ 20 -SQQ 30 \
      --bam_compression ${gatk_gkl_compression_level} \
      -L ${sep=" -L " sequence_group_interval}
  }
  runtime {
    memory: memory
    cpu: cpu
  }
  output {
    File recalibrated_bam = "${output_bam_basename}.bam"
  }
}

# Combine multiple recalibrated BAM files from scattered ApplyRecalibration runs
task GatherBamFiles {
  Array[File] input_bams
  String output_bam_basename
  String java_heap_memory
  String memory
  Int cpu
  String tool_path  
  String tmp_directory

  command {
    java -Djava.io.tmpdir=${tmp_directory} -Xmx${java_heap_memory} -jar ${tool_path}/picard.jar \
      GatherBamFiles \
      INPUT=${sep=' INPUT=' input_bams} \
      OUTPUT=${output_bam_basename}.bam \
      CREATE_INDEX=true \
      CREATE_MD5_FILE=true
    }
  runtime {
      memory: memory
    cpu: cpu
  }
  output {
    File output_bam = "${output_bam_basename}.bam"
    File output_bam_index = "${output_bam_basename}.bai"
    File output_bam_md5 = "${output_bam_basename}.bam.md5"
  }
}

# Call variants on a single sample with HaplotypeCaller to produce a GVCF
task HaplotypeCaller {
  File input_bam
  File input_bam_index
  File interval_list
  Int interval_padding
  String gvcf_basename
  File ref_dict
  File ref_fasta
  File ref_fasta_index
  String gatk_gkl_compression_level
  String gatk_gkl_pairhmm_implementation
  Int gatk_gkl_pairhmm_threads
  String memory
  Int cpu
  String java_heap_memory
  String tmp_directory
  String tool_path
  
  command {
    java -Djava.io.tmpdir=${tmp_directory} -Xmx${java_heap_memory} \
      -jar ${tool_path}/GATK38.jar \
      -T HaplotypeCaller \
      -R ${ref_fasta} \
      -o ${gvcf_basename}.vcf.gz \
      -I ${input_bam} \
      -L ${interval_list} \
      -ip ${interval_padding} \
      -ERC GVCF \
      --max_alternate_alleles 3 \
      -variant_index_parameter 128000 \
      -variant_index_type LINEAR \
      --read_filter OverclippedRead \
      --bam_compression ${gatk_gkl_compression_level} \
      --pair_hmm_implementation ${gatk_gkl_pairhmm_implementation} \
      --nativePairHmmThreads ${gatk_gkl_pairhmm_threads}
  }
  runtime {
      memory: memory
    cpu: cpu
  }
  output {
    File output_gvcf = "${gvcf_basename}.vcf.gz"
    File output_gvcf_index = "${gvcf_basename}.vcf.gz.tbi"
  }
}

# Combine multiple VCFs or GVCFs from scattered HaplotypeCaller runs
task MergeVCFs {
  Array[File] input_vcfs
  Array[File] input_vcfs_indexes
  String output_vcf_name
  String java_heap_memory
  String memory
  Int cpu
  String tool_path
  String tmp_directory

  # Using MergeVcfs instead of GatherVcfs so we can create indices
  # See https://github.com/broadinstitute/picard/issues/789 for relevant GatherVcfs ticket
  command {
    java -Djava.io.tmpdir=${tmp_directory} -Xmx${java_heap_memory} -jar ${tool_path}/picard.jar \
    MergeVcfs \
    INPUT=${sep=' INPUT=' input_vcfs} \
    OUTPUT=${output_vcf_name}
  }
  output {
    File output_vcf = "${output_vcf_name}"
    File output_vcf_index = "${output_vcf_name}.idx"
  }
  runtime {
      memory: memory
    cpu: cpu
  }
}

# WORKFLOW DEFINITION 
workflow ExomeNonDockerGenericPreProcessingToGVCFWorkflow {

  String sample_name
  String base_file_name
  String final_gvcf_name
  Array[File] flowcell_unmapped_bams
  String unmapped_bam_suffix
  
  File scattered_calling_intervals_list
  File calling_interval_list
  
  File ref_fasta
  File ref_fasta_index
  File ref_dict
  File ref_alt
  File ref_bwt
  File ref_sa
  File ref_amb
  File ref_ann
  File ref_pac
  
  File dbSNP_vcf
  File dbSNP_vcf_index
  Array[File] known_indels_sites_VCFs
  Array[File] known_indels_sites_indices
  
  #Optimization flags
  Int bwa_threads
  Int samtools_threads
  Int gatk_gkl_compression_level
  String gatk_gkl_pairhmm_implementation
  Int gatk_gkl_pairhmm_threads

  String tool_path 
  String tmp_directory

  String bwa_commandline="bwa mem -K 100000000 -p -v 3 -t $bwa_threads -Y $bash_ref_fasta"

  String recalibrated_bam_basename = base_file_name + ".aligned.duplicates_marked.recalibrated"

  Array[File] scattered_calling_intervals = read_lines(scattered_calling_intervals_list)

  # Get the version of BWA to include in the PG record in the header of the BAM produced 
  # by MergeBamAlignment. 
  call GetBwaVersion {
    input: 
	   tool_path = tool_path
  }

  # Align flowcell-level unmapped input bams in parallel
  scatter (unmapped_bam in flowcell_unmapped_bams) {
  
    # Because of a wdl/cromwell bug this is not currently valid so we have to sub(sub()) in each task
    # String base_name = sub(sub(unmapped_bam, "gs://.*/", ""), unmapped_bam_suffix + "$", "")
    # Replace the below path with your shared filesystem path.
    String sub_strip_path = "/cluster_share/data/RefArch_Broad_data/.*/"
    String sub_strip_unmapped = unmapped_bam_suffix + "$"

    # Map reads to reference
    # Supports MT
    call SamToFastqAndBwaMem {
      input:
        input_bam = unmapped_bam,
        bwa_commandline = bwa_commandline,
        output_bam_basename = sub(sub(unmapped_bam, sub_strip_path, ""), sub_strip_unmapped, "") + ".unmerged",
        ref_fasta = ref_fasta,
        ref_fasta_index = ref_fasta_index,
        ref_dict = ref_dict,
        ref_alt = ref_alt,
        ref_bwt = ref_bwt,
        ref_amb = ref_amb,
        ref_ann = ref_ann,
        ref_pac = ref_pac,
        ref_sa = ref_sa,
        bwa_threads = bwa_threads, 
        samtools_threads = samtools_threads,
        tmp_directory = tmp_directory,
		tool_path = tool_path
     }

    # Merge original uBAM and BWA-aligned BAM 
    # Doesn't support MT
    call MergeBamAlignment {
      input:
        unmapped_bam = unmapped_bam,
        bwa_commandline = bwa_commandline,
        bwa_version = GetBwaVersion.version,
        aligned_bam = SamToFastqAndBwaMem.output_bam,
        output_bam_basename = sub(sub(unmapped_bam, sub_strip_path, ""), sub_strip_unmapped, "") + ".aligned.unsorted",
        ref_fasta = ref_fasta,
        ref_fasta_index = ref_fasta_index,
        ref_dict = ref_dict,
        bwa_threads = bwa_threads,
        tmp_directory = tmp_directory,
		tool_path = tool_path
    }

    # Sort and fix tags in the merged BAM
    # Doesn't support MT
    call SortAndFixTags as SortAndFixReadGroupBam {
      input:
      input_bam = MergeBamAlignment.output_bam,
      output_bam_basename = sub(sub(unmapped_bam, sub_strip_path, ""), sub_strip_unmapped, "") + ".sorted",
      ref_dict = ref_dict,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      tmp_directory = tmp_directory,
	  tool_path = tool_path
    }

  }

  # Aggregate aligned+merged flowcell BAM files and mark duplicates
  # We take advantage of the tool's ability to take multiple BAM inputs and write out a single output
  # to avoid having to spend time just merging BAM files.
  # Doesn't support MT
  call MarkDuplicates {
    input:
      input_bams = MergeBamAlignment.output_bam,
      output_bam_basename = base_file_name + ".aligned.unsorted.duplicates_marked",
      metrics_filename = base_file_name + ".duplicate_metrics",
      tmp_directory = tmp_directory,
	  tool_path = tool_path
  }

  # Sort aggregated+deduped BAM file and fix tags
  # Doesn't support MT
  call SortAndFixTags as SortAndFixSampleBam {
    input:
      input_bam = MarkDuplicates.output_bam,
      output_bam_basename = base_file_name + ".aligned.duplicate_marked.sorted",
      ref_dict = ref_dict,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      tmp_directory = tmp_directory,
	  tool_path = tool_path
  }

  # Create list of sequences for scatter-gather parallelization 
  call CreateSequenceGroupingTSV {
    input:
      ref_dict = ref_dict
  }
  
  # Perform Base Quality Score Recalibration (BQSR) on the sorted BAM in parallel
  scatter (subgroup in CreateSequenceGroupingTSV.sequence_grouping) {
    # Generate the recalibration model by interval
    # Supports MT with -nct: is it beneficial to use -nct > 1? Probably not, just use scatter-gather
    call BaseRecalibrator {
      input:
        input_bam = SortAndFixSampleBam.output_bam,
        input_bam_index = SortAndFixSampleBam.output_bam_index,
        recalibration_report_filename = base_file_name + ".recal_data.csv",
        sequence_group_interval = subgroup,
        dbSNP_vcf = dbSNP_vcf,
        dbSNP_vcf_index = dbSNP_vcf_index,
        known_indels_sites_VCFs = known_indels_sites_VCFs,
        known_indels_sites_indices = known_indels_sites_indices,
        ref_dict = ref_dict,
        ref_fasta = ref_fasta,
        ref_fasta_index = ref_fasta_index,
        gatk_gkl_compression_level = gatk_gkl_compression_level,
        tmp_directory = tmp_directory,
		tool_path = tool_path
    }  
  }  
  
  # Merge the recalibration reports resulting from by-interval recalibration
  call GatherBqsrReports {
    input:
      input_bqsr_reports = BaseRecalibrator.recalibration_report,
      output_report_filename = base_file_name + ".recal_data.csv",
      tmp_directory = tmp_directory,
	  tool_path = tool_path
  }

  scatter (subgroup in CreateSequenceGroupingTSV.sequence_grouping_with_unmapped) {

    # Apply the recalibration model by interval
    # Supports MT with -nct: is it beneficial to use -nct > 1? Probably not, just use scatter-gather
    call ApplyBQSR {
      input:
        input_bam = SortAndFixSampleBam.output_bam,
        input_bam_index = SortAndFixSampleBam.output_bam_index,
        output_bam_basename = recalibrated_bam_basename,
        recalibration_report = GatherBqsrReports.output_bqsr_report,
        sequence_group_interval = subgroup,
        ref_dict = ref_dict,
        ref_fasta = ref_fasta,
        ref_fasta_index = ref_fasta_index,
        gatk_gkl_compression_level = gatk_gkl_compression_level,
        tmp_directory = tmp_directory,
		tool_path = tool_path
    }
  } 

  # Merge the recalibrated BAM files resulting from by-interval recalibration
  call GatherBamFiles {
    input:
      input_bams = ApplyBQSR.recalibrated_bam,
      output_bam_basename = base_file_name,
      tmp_directory = tmp_directory,
	  tool_path = tool_path
  }
  
  # Call variants in parallel over calling intervals
  scatter (subInterval in scattered_calling_intervals) {
  
    # Generate GVCF by interval
    # Supports MT with -nct: is it beneficial to use -nct > 1? Probably not, just use scatter-gather
    # PairHMM can be run in parallel - again, not beneficial since the Java side cannot feed data
    # Disable and use scatter-gather only
    call HaplotypeCaller {
      input:
        input_bam = GatherBamFiles.output_bam,
        input_bam_index = GatherBamFiles.output_bam_index,
        interval_list = subInterval,
        gvcf_basename = base_file_name,
        ref_dict = ref_dict,
        ref_fasta = ref_fasta,
        ref_fasta_index = ref_fasta_index,
        gatk_gkl_compression_level = gatk_gkl_compression_level, 
        gatk_gkl_pairhmm_implementation = gatk_gkl_pairhmm_implementation, 
        gatk_gkl_pairhmm_threads = gatk_gkl_pairhmm_threads,
        tmp_directory = tmp_directory,
		tool_path = tool_path
     }
  }
  
  # Combine by-interval GVCFs into a single sample GVCF file
  call MergeVCFs {
    input:
      input_vcfs = HaplotypeCaller.output_gvcf,
      input_vcfs_indexes = HaplotypeCaller.output_gvcf_index,
      output_vcf_name = final_gvcf_name,
      tmp_directory = tmp_directory,
	  tool_path = tool_path
  }

  # Outputs that will be retained when execution is complete  
  output {
    File duplication_metrics = MarkDuplicates.duplicate_metrics
    File bqsr_report = GatherBqsrReports.output_bqsr_report
    File analysis_ready_bam = GatherBamFiles.output_bam
    File analysis_ready_bam_index = GatherBamFiles.output_bam_index
    File analysis_ready_bam_md5 = GatherBamFiles.output_bam_md5
    File final_output_gvcf = MergeVCFs.output_vcf
    File final_output_gvcf_index = MergeVCFs.output_vcf_index
  } 
}
