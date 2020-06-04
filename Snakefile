include: "rules/common.smk"

# =================================================================================================
#     Default "All" Target Rule
# =================================================================================================

bam_basenames = [ os.path.basename(bam) for bam in get_all_bams() ]

# The rule that is executed by default. It collects data from all anaylysis tools.
# Simply comment or uncomment as needed. We might change this to using config later.
rule all:
    input:
        # bamfreq
        expand( config["rundir"] + "bamfreq/{bam_basenames}.freq", bam_basenames=bam_basenames ),

        # Plink
        config["rundir"] + "plink/freq.frq",

        # PoPoolation
        config["rundir"] + "popoolation/varslid.pdf",

# The main `all` rule is local. It does not do anything anyway,
# except requesting the other rules to run.
localrules: all

# =================================================================================================
#     Rule Modules
# =================================================================================================

include: "rules/bamfreq.smk"
include: "rules/plink.smk"
include: "rules/popoolation.smk"

# =================================================================================================
#     Subworkflow for grenepipe
# =================================================================================================

# Test for making grenepipe a subworkflow here. Not used as of now, but might come in handy later.

# subworkflow grenepipe:
#     workdir:
#         "../grenepipe"
#     snakefile:
#         "../grenepipe/Snakefile"
#     configfile:
#         "../grenepipe/run-f-100k/config.yaml"

# Alternatevely, we could try something simple:
# include: "../grenepipe/Snakefile"
