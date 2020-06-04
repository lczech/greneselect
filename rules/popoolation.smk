# =================================================================================================
#     PoPoolation
# =================================================================================================

# Unfortunately, PoPoolation needs uncompressed pileup files...
rule popoolation_pileup:
    input:
        ref=config["data"]["reference"]["genome"],

        # Get the bam and bai files for all samples.
        samples=get_all_bams(),
        indices=get_all_bais(),
    output:
        config["rundir"] + "popoolation/all.pileup"
        # temp( config["rundir"] + "popoolation/all.pileup" )
    log:
        config["rundir"] + "logs/popoolation/pileup.log"
    conda:
        "../envs/popoolation.yaml"
    shell:
        "samtools mpileup -f {input.ref} {input.samples} > {output} 2> {log}"

rule popoolation:
    input:
        pileup=config["rundir"] + "popoolation/all.pileup"
    output:
        config["rundir"] + "popoolation/varslid.pdf"
    log:
        config["rundir"] + "logs/popoolation/run.log"
    conda:
        "../envs/popoolation.yaml"
    shell:
        "scripts/popoolation.sh {input.pileup} \"" + get_contig_list() + "\" {output} > {log} 2>&1"
