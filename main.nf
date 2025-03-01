#!/usr/bin/env nextflow
include {FASTQC} from './modules/fastqc'
include {EXTRACT_ENSEMBL} from './modules/extract_ensembl'
include {STAR_INDEX} from './modules/star'
include {STAR_ALIGN} from './modules/star_align'
include {MULTIQC} from './modules/multiqc'
include {VERSE} from './modules/verse'
include {CONCAT_COUNTS} from './modules/concat'

workflow {

    align_ch = Channel
        .fromFilePairs(params.reads)
        
    fastqc_channel = align_ch
    .flatMap { sample, files -> files.collect { file -> tuple(sample, file) } }

    gtf_channel = Channel.of(["gencode_v45", file(params.annotation)])   

    // Performing quality control
    FASTQC(fastqc_channel)

    // get ensembl names and STAR aligning reads to the genome
    EXTRACT_ENSEMBL(gtf_channel)
    STAR_INDEX(params.genome, params.annotation)
    STAR_ALIGN(STAR_INDEX.out.index, align_ch)
    
    // Collect all FASTQC and STAR log outputs
    multiqc_ch = STAR_ALIGN.out.log.mix(FASTQC.out.zip).flatten().collect()

    MULTIQC(multiqc_ch)

    // Run VERSE on each BAM file
    // Collect BAM files from STAR_ALIGN output and use in VERSE
    // get name of sample and sample BAM file
    bam_files_ch = STAR_ALIGN.out.bam.map { bam_path -> 
                    def sample_name = bam_path.baseName.replaceAll("Aligned.out", "") // Extract sample name
                    tuple(sample_name, bam_path)
                    }
    // bam_files_ch.view()
    
    VERSE(bam_files_ch, params.annotation)

    // Run concatenation with collected VERSE outputs
    //VERSE.out.collect().view()

    CONCAT_COUNTS(VERSE.out.collect()) 
}


// Notes to self:
// add container to all processes: like container 'ghcr.io/bf528/fastqc:latest'
// FastQC: ghcr.io/bf528/fastqc:latest

// multiQC: ghcr.io/bf528/multiqc:latest

// VERSE: ghcr.io/bf528/verse:latest

// STAR: ghcr.io/bf528/star:latest

// Pandas: ghcr.io/bf528/pandas:latest


// module load miniconda
// conda activate nextflow_base
// nextflow run main.nf -profile singularity,cluster
// /projectnb/bf528/students/mindyt5/project-1-mindy-tran


/*
(nextflow_base)[mindyt5@scc-wi1 project-1-mindy-tran]$ nextflow run main.nf -profile singularity,cluster
Nextflow 24.10.4 is available - Please consider updating your version to it

 N E X T F L O W   ~  version 24.04.2

Launching `main.nf` [disturbed_payne] DSL2 - revision: 87d1fd1441 
executor >  sge (14)
[27/70a73a] FASTQC (4)          | 12 of 12 ✔
[e8/94f709] EXTRACT_ENSEMBL (1) | 1 of 1 ✔
[94/e640b4] STAR_INDEX          | 1 of 1 ✔

Completed at: 27-Feb-2025 16:25:10
Duration    : 40m 25s
CPU hours   : 9.5
Succeeded   : 14



nextflow run main.nf -resume 15374610-c825-4c2d-9c8a-2536fd82e673
*/
