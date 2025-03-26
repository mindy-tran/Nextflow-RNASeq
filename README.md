# RNASeq
Created a Nextflow pipeline to explore published bulk RNAseq data using R, Python, and Linux to automate quality control, alignment, quantification, differential expression analysis, and gene set enrichment analysis.

Reproduced figures 3C and 3F from:
Chandra, V., Ibrahim, H., Halliez, C. et al. The type 1 diabetes gene TYK2 regulates β-cell development and its responses to interferon-α. Nat Commun 13, 6363 (2022). https://doi.org/10.1038/s41467-022-34069-z

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
