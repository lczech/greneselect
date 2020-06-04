# =================================================================================================
#     PLINK
# =================================================================================================

rule frequencies_plink:
    input:
        config["data"]["called_variants"]
    output:
        config["rundir"] + "plink/freq.frq",
        config["rundir"] + "plink/freq.frq.counts"
    params:
        out_prefix = config["rundir"] + "plink/freq"
    log:
        config["rundir"] + "logs/plink/freq.log"
    conda:
        "../envs/plink.yaml"
    shell:
        "plink --vcf {input} --freq        --allow-extra-chr --out {params.out_prefix} >  {log} 2>&1 ;"
        "plink --vcf {input} --freq counts --allow-extra-chr --out {params.out_prefix} >> {log} 2>&1"
