#!/usr/bin/env nextflow

process VERSE {
    label 'process_high'
    container 'ghcr.io/bf528/verse:latest'
    publishDir params.outdir, mode: 'copy'
    conda "envs/verse_env.yml"

    input:
    tuple val(sample), path(bam)  // BAM file
    path(annotation) // GTF annotation file


    output:
    path "*"  // Output quantification file

    script:
    """
    verse -a $annotation -o ${sample} -S $bam
    """
}