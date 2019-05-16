#!/usr/bin/env bash
# Switches to n-th (default n=last) session when listed alphabetically
if [[ -n $1 ]]; then
	session=$(tmux list-sessions -F '#{session_id}' | sed -n "$1p")
else
	session=$(tmux list-sessions -F '#{session_id}' | tail -1)
fi
tmux switch-client -t $session
