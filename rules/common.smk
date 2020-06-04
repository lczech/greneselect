# =================================================================================================
#     Dependencies
# =================================================================================================

import pandas as pd
import os
import glob

# Ensure min Snakemake version
snakemake.utils.min_version("5.7")

# =================================================================================================
#     Basic Configuration
# =================================================================================================

# We check if snakemake was called with what we call the run directory ("rundir"),
# e.g., `snakemake --config rundir="my-run"`, which is the target directory to write all files to.
# If not, we simply write files to the current directory. We explicitly use the run dir instead
# of the working directory offered by snakemake, as the latter makes ALL paths relative to that dir,
# which would mean that we have to re-specify all input file paths as well, and re-load all conda
# modules, etc...
#
# Furthermore, we check if the rundir contains a "config.yaml" configuration file, and load this
# instead of the config.yaml in the main snakemake directory.
# This is useful to have runs that have different settings, but generally re-use the main setup.
if "rundir" in config.keys():
    cfg=os.path.join(config["rundir"], "config.yaml")
    if os.path.isfile(cfg):
        configfile: cfg
    else:
        configfile: "config.yaml"
else:
    config["rundir"] = ""
    configfile: "config.yaml"
if config["rundir"] and not config["rundir"].endswith("/"):
    config["rundir"] += "/"
# snakemake.utils.validate(config, schema="../schemas/config.schema.yaml")

# =================================================================================================
#     Read Samples File
# =================================================================================================

# Read samples and units table
samples = pd.read_table(config["data"]["samples"], dtype=str).set_index(["sample", "unit"], drop=False)
samples.index = samples.index.set_levels([i.astype(str) for i in samples.index.levels])  # enforce str in index
snakemake.utils.validate(samples, schema="../schemas/samples.schema.yaml")

# Transform for ease of use
sample_names=list(set(samples.index.get_level_values("sample")))
unit_names=list(set(samples.index.get_level_values("unit")))

# Wildcard constraints: only allow sample names from the spreadsheet to be used
wildcard_constraints:
    sample="|".join(sample_names),
    unit="|".join(unit_names)
    # vartype="snvs|indels" TODO?!

# =================================================================================================
#     Common Helper Functions
# =================================================================================================

def get_fai():
    return config["data"]["reference"]["genome"] + ".fai"

# contigs in reference genome
def get_contigs():
    return pd.read_table(get_fai(), header=None, usecols=[0], squeeze=True, dtype=str)

def get_contig_list():
    return " ".join(get_contigs())

# Return the bam file(s) for all samples
def get_all_bams():
    bams = glob.glob( os.path.join( config["data"]["mapped_samples"], "*.bam"))
    if len(bams) != len(sample_names):
        raise Exception(
            "Found " + str(len(bams)) + " bam files in " + config["data"]["mapped_samples"] +
            ", but expected " + str(len(sample_names)) + " files due to samples table."
        )
    return bams

# Return the bai file(s) for all samples
def get_all_bais():
    bais = glob.glob( os.path.join( config["data"]["mapped_samples"], "*.bai"))
    if len(bais) != len(sample_names):
        raise Exception(
            "Found " + str(len(bais)) + " bai files in " + config["data"]["mapped_samples"] +
            ", but expected " + str(len(sample_names)) + " files due to samples table."
        )
    return bais
