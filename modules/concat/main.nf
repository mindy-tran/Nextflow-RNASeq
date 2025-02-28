#!/usr/bin/env nextflow

process CONCAT_COUNTS {
    label 'process_medium'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path(verse_outputs)

    output:
    path "concat_counts_matrix.tsv"

    script:
    """
    python3 bin/concat_counts.py -i $verse_outputs -o concat_counts_matrix.tsv
    """
}