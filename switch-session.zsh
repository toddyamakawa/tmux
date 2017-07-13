#!/usr/bin/env zsh

# Switch to next/prev session in alphabetical order

current=$(tmux display-message -p '#S')
sessions=$(tmux list-sessions -F '#S')

if [[ $1 == 'next' ]]; then
	session=$(sed -n "/^$current\$/{n;p}" <(echo $sessions))
	[[ -z $session ]] && session=$(head -n 1 <(echo $sessions))
elif [[ $1 == 'prev' ]]; then
	session=$(sed -n "/^$current\$/{x;p};x" <(echo $sessions))
	[[ -z $session ]] && session=$(tail -n 1 <(echo $sessions))
fi

tmux switch-client -t $session

