#!/usr/bin/env bash

# Returns: Total, Idle
function current-usage() {
	awk \
		'/^cpu[[:space:]]/ {
			for(i=1;i<=NF;i++){sum+=$i}
			print sum, $5
		}' \
		/proc/stat
}

# Declare arrays
declare -a usage
declare -a new_usage

# Default red color
color=9

# Get usage 1 second apart
usage=($(current-usage))

# If unable to calculate usage
if [[ ${#usage[@]} -eq 0 ]]; then
	echo "#[fg=colour$color][??%]#[fg=default]"
	exit
fi

# Wait 1 second before getting new usage
sleep 1
new_usage=($(current-usage))

# Calculate idle%
pidle=$(( 100 * (${new_usage[1]}-${usage[1]}) / (${new_usage[0]}-${usage[0]}) ))

# Get total percent usage (100% - idle%)
pusage=$((100-$pidle))

# Format color based on usage
if [[ $pusage -lt 40 ]]; then
	color=10
elif [[ $pusage -lt 80 ]]; then
	color=11
fi

# Print usage% with tmux format
echo "#[fg=colour$color][$pusage%]#[fg=default]"

