# assembly_evaluation
Workflows for evaluating genome assemblies in spruce project.

## How to run

1. Make a dedicated conda environment and activate it.
```
conda create -n snakemake
conda activate snakemake
```

2 Install snakemake and dependencies. 
```
conda install -c conda-forge -c bioconda snakemake
```
3. Clone the repository
```
git clone https://github.com/n-equals-one/assembly_evaluation.git
```

4. Make a folder for the input data in the new folder and copy the assembly to validate and transcriptome sets to map.
```
cd assembly_evaluation
mkdir data
cp /path/to/assembly.fa data/
cp /path/to/transcriptome.fa data/
cp /path/to/high_quality_transcripts.fa data/
``` 

5. Edit the config file to point to the desired input.
```
# Assembly fasta file
assembly_fasta: data/assembly.fa

# Transcriptome fasta file
transcriptome_fasta: data/transcriptome.fa

# High quality transcripts fasta
transcripts_hq_fasta: data/high_quality_transcripts.fa
```

Give a descriptive name to your cluster profile (now "test_slurm") and add the name of your cluster account (replace "test_account" below with a valid account name.
```

# Cluster configuration
cluster:
    cookiecutter_url: https://github.com/Snakemake-Profiles/slurm
    profile_name: test_slurm
    use-conda: true
    restart-times: 0
    jobs: 10 
    latency-wait: 120

    # Parameters specific for the cookiecutter template
    account: test_account
    output: "logs/slurm-%j.out"
    error: "logs/slurm-%j.err"
    partition: core
    submit_script: slurm-submit-advanced.py
```

6. First run the rule "cluster_config" like this to prepare files needed for slurm.
```
snakemake --use-conda cluster_config
```
This will create the folder "$HOME/.config/snakemamake/test_slurm" if run as above.

7. Run the complete wokflow or desired parts. No need to use "--use-conda" for subsequent steps since it is take care of by the cluster profile.
In order to pick up the settings correctly run it like this with full path to "slurm.yaml" (only running quast rule in this example case):
```
snakemake --profile spruce_slurm --cluster-config /full/path/to/cluster/slurm.yaml quast
```

## Output

The output is collected in the folder "results/".
There should be one output folder for each analysis (quast, busco, gmap etc.)
