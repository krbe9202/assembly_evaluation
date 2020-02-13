import os
from pathlib import Path
from snakemake.utils import validate

configfile: "config.yaml"
validate(config, "schemas/config.schema.yaml")

localrules: all, cluster_config

rule all:
    input: "results/quast_results/",
           "results/busco_out/",
           "results/gmap_indexed_assembly/",
           "results/transcriptome_gmap/transcriptome_gmap.gff",
           "results/transcripts_hq_gmap/transcriptome_hq.gff"

rule quast:
    input:
        assembly=config["assembly_fasta"]
    output: directory("results/quast_results/")
    conda: "envs/quast.yaml"
    shell: "quast.py --eukaryote --large --est-ref-size 20000000000 {input} -o {output}"

rule busco:
    input:
        assembly=config["assembly_fasta"]
    output: directory("results/busco_out/")
    conda: "envs/busco.yaml"
    shell: "busco -f -m genome -i {input} -o results/busco_out -l fungi_odb10" # Add as needed, this is just for testing.

rule index_for_gmap:
    input:
        assembly=config["assembly_fasta"]
    output: directory("results/gmap_indexed_assembly/")
    conda: "envs/gmap.yaml"
    shell: "gmap_build -d gmap_indexed_assembly -D results/ {input}"

rule gmap_transcripts:
    input: transcriptome=config["transcriptome_fasta"]
    output: "results/transcriptome_gmap/transcriptome_gmap.gff" 
    conda: "envs/gmap.yaml"
    shell: "gmap -d gmap_indexed_assembly -D results/ {input} -f 2 > {output}"

rule gmap_hq:
    input: transcriptome_hq=config["transcripts_hq_fasta"]
    output: "results/transcripts_hq_gmap/transcriptome_hq.gff"
    conda: "envs/gmap.yaml"
    shell: "gmap -d gmap_indexed_assembly -D results/ {input} -f 2 > {output}"
  
# TODO: add minimap2 here as well. 
#rule minimap:
#    input: assembly=config["assembly_fasta"]
#    output:
#    shell:

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
