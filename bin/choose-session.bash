#!/usr/bin/env bash
tmux list-sessions -F "#{session_id} '#{session_name}'" \
	| awk '{ cmd="'"'"'switch-client -t "$1"'"'"'"
		key="'"'"'"counter++"'"'"'"
		$1=""
		print $0, key, cmd
	}' \
	| xargs tmux display-menu -y S

