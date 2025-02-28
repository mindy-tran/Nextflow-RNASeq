#!/usr/bin/env nextflow

process STAR_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest'
    publishDir params.outdir, mode: 'copy'
    conda "envs/star_env.yml"

    input:
    path(genome_index)
    tuple val(sample), path(reads)
    

    output:
    path "*bam", emit: bam
    path "*Log.final.out", emit: log

    script:
    """
    STAR --runThreadN $task.cpus \\
         --genomeDir $genome_index \\
         --readFilesIn $reads \\
         --readFilesCommand zcat \\
         --outFileNamePrefix $sample \\
         --outSAMtype BAM Unsorted
    """
}