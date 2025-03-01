#!/usr/bin/env python3

import argparse
import pandas as pd
from pathlib import Path

def read_counts(file_path):
    """ 
    Reads a VERSE exon count file into a one counts matrix. 
    """
    df = pd.read_csv(file_path, sep='\t', header=0)
    sample_name = Path(file_path).stem.replace('.exon', '')  # get sample name
    df = df.set_index('gene')  # gene names as index
    df.columns = [sample_name]  # count column to sample name
    return df

def main():
    parser = argparse.ArgumentParser(description="Concatenate all VERSE output files and write a single counts matrix containing all of your samples.")
    parser.add_argument("-i", "--input", nargs='+', required=True, help="List of VERSE exon count files.")
    parser.add_argument("-o", "--output", required=True, help="Output file for concatenated counts matrix.")
    args = parser.parse_args()

    # Read all count files and merge into one, expluding summary files
    count_dfs = [read_counts(file) for file in args.input if "summary" not in file]
    merged_df = pd.concat(count_dfs, axis=1).fillna(0)  # Merge on gene names, fill missing with 0

    # Save merged counts matrix
    merged_df.to_csv(args.output, sep='\t')

if __name__ == "__main__":
    main()
