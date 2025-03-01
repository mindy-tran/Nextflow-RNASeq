#!/usr/bin/env nextflow

process CONCAT_COUNTS {
    label 'process_medium'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode: 'copy'
    conda "envs/biopython_env.yml"

    input:
    path(verse_outputs)

    output:
    path "concat_counts_matrix.tsv"
    // ${verse_outputs.join(' ')}

    script:
    """
    concat_counts.py -i ${verse_outputs.join(' ')} -o concat_counts_matrix.tsv
    """
}