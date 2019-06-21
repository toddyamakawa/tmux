#!/usr/bin/env bash
session=${1-$(tmux display-message -p "#{session_name}")}
declare -r backup_dir=$HOME/.tmux/saved-sessions/$session
declare -r save_file=$(ls -1 $backup_dir/*.tmux |& tail -1)

# Find save file
if [[ ! -f $save_file ]]; then
	echo "Unable to find save file for session '$session'"
	exit 1
fi

# Verbosity
function echov() {
	verbosity=1
	verbosity=0
	[[ $verbosity -ge 1 ]] && echo $@
}

shell=zsh
prev_index=-1

# Restore from save file
while IFS=$'\t' read index name path; do

	# Create new session if necessary
	if ! (tmux has-session -t $session); then
		pane_id=$(TMUX='' tmux new-session -d -s $session -n $name -c $path -P -F '#{pane_id}' $shell)
		echov "new session $session $name $path $pane_id"
	else

		# Create new window if necessary
		if [[ $index -ne $prev_index ]]; then
			pane_id=$(tmux new-window -n $name -c $path -t $session -P -F '#{pane_id}' $shell)
			echov "new window $session $name $path $pane_id"

		# Create new pane by splitting window
		else
			tmux split-window -h -t $pane_id -c $path $shell
			tmux select-layout -t $pane_id -E
			echov "new pane $session $name $path $pane_id"
		fi
	fi

	prev_index=$index
done < $save_file

