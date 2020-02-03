import os
from pathlib import Path
from snakemake.utils import validate

configfile: 'config.yaml'
validate(config, 'schemas/config.schema.yaml')

localrules: all, cluster_config

rule all:
    input: "quast_results/report.tsv",

rule quast:
    input:
        assembly=config["assembly_fasta"]
    output: "quast_results/report.tsv"
    conda: "envs/quast.yaml"
    shell: "quast.py --eukaryote --large --est-ref-size 20000000000 {input} -o quast_results"

rule cluster_config:
    '''
    Generate a cluster profile.
    '''
    output: directory( \
        '{home}/.config/snakemake/{profile_name}' \
            .format(home=Path.home(), \
                    profile_name=config['cluster']['profile_name']))
    params:
        url=config['cluster']['cookiecutter_url'],
        profile_name=config['cluster']['profile_name']
    conda: 'envs/cluster_config.yaml'
    shell: 'bash scripts/cluster_config.sh {params.url} {params.profile_name}'
