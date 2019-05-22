#!/usr/bin/env zsh

# --- Parse Arguments ---
colorscheme=${1-default}
verbose=$2


# --- Colorschemes ---
red='15 210 203 9 160 52'
yellow='15 229 227 190 11 94'
green='15 156 82 46 70 22'
blue='15 159 14 39 33 19'
purple='15 147 141 129 93 53'
black='239 243 249 249 243 239'

default=$blue
[[ -n $LSB_BATCH_JID ]] && default=$yellow

# Set colorscheme
read -r white lightest light medium dark darkest <<<$(eval echo \$$colorscheme)


# --- Print Colors ---
if [[ -n $verbose ]]; then
	function cprint() {
		local color=$1 value
		value=$(eval echo \$$color)
		echo "\x1b[38;5;${value}m${color}"
	}
	cprint white
	cprint lightest
	cprint light
	cprint medium
	cprint dark
	cprint darkest
fi


# --- Set tmux Colors ---

# Pane borders
tmux set-option -g pane-border-fg        colour$darkest
tmux set-option -g pane-active-border-fg colour$medium

# Status bar
tmux set-option        -g status-fg                colour$dark
tmux set-window-option -g window-status-fg         colour$white
tmux set-window-option -g window-status-current-fg colour$light
tmux set-window-option -g window-status-last-fg    colour$lightest

