#!/bin/bash

for d in `ls -d */` ; do
    cd $d
    if [ -f "Snakefile" ]; then
        echo "Processing $d"
        snakemake --rulegraph | dot -Tsvg > rulegraph.svg
    fi
    cd ..
done
