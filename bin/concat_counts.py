#!/usr/bin/env python3

import argparse
import pandas as pd
from pathlib import Path

def main(input_dir, output_file):
    input_path = Path(input_dir)
    output_path = Path(output_file)

    # Find all VERSE output files
    files = list(input_path.glob("*_quant.tsv"))
    if not files:
        raise ValueError("No VERSE output files.")

    # Read and merge all VERSE outputs
    count_dfs = []
    for file in files:
        sample_name = file.stem.replace("_quant", "")  # Extract sample name
        df = pd.read_csv(file, sep="\t", index_col=0, header=0)  # Read as DataFrame
        df.columns = [sample_name]  # Rename column to sample name
        count_dfs.append(df)

    # Merge all dataframes on gene names
    merged_df = pd.concat(count_dfs, axis=1).fillna(0)  # Fill missing values with 0
    merged_df.to_csv(output_path, sep="\t")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Concatenate all VERSE counts output files and writes a single counts matrix containing all of your samples.")
    parser.add_argument("-i", "--input_dir", required=True, help="Directory with VERSE output files.")
    parser.add_argument("-o", "--output_file", required=True, help="Output file path for the final count matrix.")
    
    args = parser.parse_args()
    main(args.input_dir, args.output_file)
