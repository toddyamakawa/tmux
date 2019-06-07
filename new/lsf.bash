#!/usr/bin/env bash

# Immediately exit on failure
set -eo pipefail

source /arm/tools/setup/init/bash
umask 002
module load core eda swdev util arm/cluster/2.0
mrun=/arm/tools/setup/bin/mrun

_LSF_DESCRIPTION=regress_tb-EA-sim_mti
_LSF_RUNLIMIT=685:30
_LSF_RHE='(rhe7||rhe6)'

eval bsub \
	-Jd $_LSF_DESCRIPTION \
	-R "'select[$_LSF_RHE && x86_64 && os64]'" \
	-W $_LSF_RUNLIMIT -M 16384000 \
	-app FG \
	-Is \
	-XF \
	/arm/tools/zsh/zsh/5.0.2/rhe6-x86_64/bin/zsh

