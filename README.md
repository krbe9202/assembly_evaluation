# assembly_evaluation
Workflows for evaluating genome assemblies in spruce project.

## How to run

1. Make a dedicated conda environment and activate it.
2. Install snakemake and dependencies. 
```
conda install -c conda-forge -c bioconda snakemake
```
        
3. Clone the repository
4. Make a folder for the input data.
5. Edit the config file to point to the desired input.
6. Run snakemake --use-conda cluster_config to prepare files needed for slurm.
7. Run the complete wokflow "snakemake" or desired parts.
    In order to pick up the settings correctly run it like this (only running quast rule in this case):
    snakemake --profile spruce_slurm --cluster-config /full/path/to/cluster/slurm.yaml quast

## Output

The output is collected in the folder "results/".
There should be one output folder for each analysis (quast, busco, gmap etc.)
A short summary of the run and results are in the file: run_summary.txt # Change this?






