#!/usr/bin/env python

import argparse

# Initialize argument parser
parser = argparse.ArgumentParser(description="Parse GTF file to extract Ensembl gene IDs and gene names.")

parser.add_argument("-i", "--input", help="Path to the GTF file", dest="input", required=True)
parser.add_argument("-o", "--output", help="Output file for gene ID and name mapping", dest="output", required=True)

# Parse arguments
args = parser.parse_args()

# Open the GTF file and extract Ensembl gene ID and gene name
with open(args.input, 'rt') as infile, open(args.output, 'w') as outfile:
    outfile.write("Ensembl_ID\tGene_Name\n")  # Header row
    
    for line in infile:
        if line.startswith("#"):
            continue  # Skip header lines
        
        fields = line.strip().split("\t")
        if fields[2] == "gene":  # Process only gene entries
            attributes = fields[8]
            gene_id = None
            gene_name = None

            # Extract gene_id and gene_name from the attributes column
            for attr in attributes.split(";"):
                attr = attr.strip()
                if attr.startswith("gene_id"):
                    gene_id = attr.split(" ")[1].strip('\"')
                elif attr.startswith("gene_name"):
                    gene_name = attr.split(" ")[1].strip('\"')

            # Write to output file if both values are found
            if gene_id and gene_name:
                outfile.write(f"{gene_id}\t{gene_name}\n")

print(f"Parsing complete. Output written to {args.output}")
