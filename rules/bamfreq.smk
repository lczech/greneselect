import os

# =================================================================================================
#     bamfreq
# =================================================================================================

rule bamfreq:
    input:
        get_all_bams()
    output:
        [ config["rundir"] + "bamfreq/" + os.path.basename(bam) + ".freq" for bam in get_all_bams() ]
    params:
        out_prefix = config["rundir"] + "bamfreq/",
        extra = config["params"]["bamfreq"]["extra"]
    log:
        config["rundir"] + "logs/bamfreq.log"
    run:
        for bam in input:
            out_file = "{params.out_prefix}" + os.path.basename(bam) + ".freq"
            shell( "tools/bamfreq/freq {params.extra} " + bam + " > " + out_file + " 2> {log}" )
        # "bamfreq {input} > {output} 2> {log}"
