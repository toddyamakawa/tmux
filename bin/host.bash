#!/usr/bin/env bash

# --- LSF Environment ---
job=$LSB_BATCH_JID
if [[ -n $job ]]; then
	# TODO: time_left=$(bjobs -noheader -o time_left $job)
	echo "#[fg=colour11][$job]#[fg=default]"

# --- Hostname ---
else
	echo "#[fg=colour10][$(hostname --short)]#[fg=default]"
fi

