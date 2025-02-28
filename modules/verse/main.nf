#!/usr/bin/env nextflow

process VERSE {
    label 'process_high'
    container 'ghcr.io/bf528/verse:latest'
    publishDir params.outdir, mode: 'copy'
    conda "envs/verse_env.yml"

    input:
    path(bam_file)  // BAM file
    path(annotation)  // GTF annotation file


    output:
    path "*txt"  // Output quantification file

    script:
    """
    verse -a $annotation -o counts.txt -S $bam_file
    """
}