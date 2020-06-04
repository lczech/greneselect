Overview
================

This directory contains software tools that are not distributed via conda.
These tools are stored here as git submodules. If you did not obtain the greneselect pipeline
via `git clone --recursive`, you need to pull the submodules first:

    git submodule update --init --recursive

After that, some tools need to be compiled, as described in the following.

bamfreq
----------------

Submodule from https://github.com/MoisesExpositoAlonso/bamfreq

    cd bamfreq
    make submodules
    make

popoolation
----------------

Submodule from https://github.com/lczech/popoolation,
which is a fork of the original from https://sourceforge.net/p/popoolation/

No build steps necessary.
