# RNASeq
•	Creating a Nextflow pipeline to explore published bulk RNAseq data using R, Python, and Linux to automate quality control, alignment, quantification, differential expression analysis, and gene set enrichment analysis
## Objectives

- FASTQC: Performing quality control

- STAR: Aligning reads to the genome

- MultiQC: Performing post-alignment QC

- VERSE: Quantifying alignments to the genome

- R:
  * Filtered out genes with less than 10 counts across all samples for the raw counts matrix
  * Perform basic differential expression using DESeq2
  * RNAseq Quality Control Plots: sample-to-sample heatmap and PCA plots to compare control vs experimental
  * FGSEA Analysis using the C2 canonical pathways MSIGDB dataset
