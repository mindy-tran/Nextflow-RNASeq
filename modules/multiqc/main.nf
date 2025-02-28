#!/usr/bin/env nextflow

process MULTIQC {
    label 'process_low'
    container 'ghcr.io/bf528/multiqc:latest'
    publishDir params.outdir, mode: 'copy'
    conda "envs/multiqc_env.yml"

    input:
    path('*')

    output:
    path('multiqc_report.html'), emit: html

    script:
    """
    multiqc . -f
    """
}
