#!/usr/bin/env nextflow
include {FASTQC} from './modules/fastqc'
include {EXTRACT_ENSEMBL} from './modules/extract_ensembl'
include {STAR_INDEX} from './modules/star'


workflow {

    align_ch = Channel
        .fromFilePairs(params.reads, pattern: '*{R1,R2}.subset.fastq.gz')
        

    fastqc_channel = align_ch
    .flatMap { sample, files -> files.collect { file -> tuple(sample, file) } }

    gtf_channel = Channel.of(["gencode_v45", file(params.annotation)])    

    FASTQC(fastqc_channel)
    EXTRACT_ENSEMBL(gtf_channel)
    STAR_INDEX(params.genome, params.annotation)
    
}



// add container to all processes: like container 'ghcr.io/bf528/fastqc:latest'
// FastQC: ghcr.io/bf528/fastqc:latest

// multiQC: ghcr.io/bf528/multiqc:latest

// VERSE: ghcr.io/bf528/verse:latest

// STAR: ghcr.io/bf528/star:latest

// Pandas: ghcr.io/bf528/pandas:latest


// module load miniconda
// conda activate nextflow_base
// nextflow run main.nf -profile singularity,local
// /projectnb/bf528/students/mindyt5/project-1-mindy-tran