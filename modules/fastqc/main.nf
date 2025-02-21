#!/usr/bin/env nextflow

process FASTQC {
    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    publishDir params.outdir, mode: 'copy'
    conda "envs/fastqc_env.yml"

    input:
    tuple val(sample), path(file)

    output:
    tuple val(sample), path('*.zip'), emit: zip
    tuple val(sample), path('*.html'), emit: html

    script:
    """
    fastqc $file -t $task.cpus
    """
}
