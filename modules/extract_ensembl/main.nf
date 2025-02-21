#!/usr/bin/env nextflow

process EXTRACT_ENSEMBL {
    conda "envs/biopython_env.yml"
    container "ghcr.io/bf528/biopython:latest"
    label 'process_single'
    publishDir params.outdir, mode: 'copy'
    cache 'lenient'

    input:
    tuple val(name), path(gtf)

    output:
    tuple val(name), path("${name}_gene_mapping.txt")

    script:
    """
    extract_ensembl.py -i $gtf -o ${name}_gene_mapping.txt
    """
}
