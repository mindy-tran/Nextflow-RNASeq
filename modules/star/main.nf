#!/usr/bin/env nextflow

process STAR_INDEX {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest'
    publishDir params.outdir, mode: 'copy'
    conda "envs/star_env.yml"

    input:
    path(genome)
    path(annotation)

    output:
    path "star_index", emit: index

    script:
    """
    mkdir -p star_index
    STAR --runMode genomeGenerate \\
         --runThreadN $task.cpus \\
         --genomeDir star_index \\
         --genomeFastaFiles $genome \\
         --sjdbGTFfile $annotation
    """
}
