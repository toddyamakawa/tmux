#!/usr/bin/env zsh

# Returns: Total, Idle
function current-usage() {
	awk \
		'/^cpu[[:space:]]/ {
			for(i=1;i<=NF;i++){sum+=$i}
			print sum, $5
		}' \
		/proc/stat
}

# Get usage 1 second apart
prev_usage=($(current-usage))
sleep 1
usage=($(current-usage))

# Calculate idle%
pidle=$(( 100.0 * ($usage[2]-$prev_usage[2]) / ($usage[1]-$prev_usage[1]) ))

# Get total percent usage (100% - idle%)
pusage=$(printf "%0.2f" $((100-$pidle)))

# Format color based on usage
if (( $pusage < 50 )); then
	color=10
elif (( $pusage < 80 )); then
	color=11
else
	color=9
fi

# Print usage% with tmux format
echo "#[fg=colour$color][$pusage%]#[fg=default]"

