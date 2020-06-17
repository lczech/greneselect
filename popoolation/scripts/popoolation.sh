#!/bin/bash

PILEUP=${1}
CONTIGS=${2}
OUTDIR=$(dirname ${3})

# echo "PILEUP: $PILEUP"
# echo "CONTIGS: $CONTIGS"
# echo "OUTDIR: $OUTDIR"

POPOOLATION_DIR=tools/popoolation

perl ${POPOOLATION_DIR}/Variance-sliding.pl --input ${PILEUP} --measure pi --min-count 1 --min-qual 20 --min-coverage 2 --max-coverage 400 --pool-size 20 --window-size 100 --step-size 100 --output ${OUTDIR}/varslid.pi

# perl ${POPOOLATION_DIR}/Variance-sliding.pl --input ${PILEUP} --measure pi --min-count 1 --min-qual 20 --min-coverage 2 --max-coverage 400 --pool-size 20 --window-size 100 --step-size 100 --output ${OUTDIR}/varslid.pi --region "2R:7800000-8300000"

perl ${POPOOLATION_DIR}/Visualise-output.pl --input ${OUTDIR}/varslid.pi --output ${OUTDIR}/varslid.pdf --chromosomes "${CONTIGS}" --ylab pi --ymin "-0.01" --ymax "0.1"
