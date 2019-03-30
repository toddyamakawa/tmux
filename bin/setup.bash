#!/usr/bin/env bash
declare -r script=$(readlink -f $BASH_SOURCE)
declare -r script_dir=$(dirname $script)
function _git() { git -C $script_dir $@; }
declare -r top=$(_git rev-parse --show-toplevel 2>/dev/null)
declare -r now=$(date +%Y%m%d-%H%M%S)

# Print stderr in red
exec 2> >(while read line; do echo -e "\e[31m[stderr]\e[0m $line"; done)

# Print custom pipe in blue
exec 5> >(while read line; do echo -e "\e[34m$line\e[0m"; done)

# Immediately exit on failure
set -eo pipefail
#set -euo pipefail

IFS=$'\n\t'

current_tmux=$(readlink -f ~/.tmux)
current_tmux_conf=$(readlink -f ~/.tmux)

# Create ~/.tmux symlink
if [[ $current_tmux != $top ]]; then
	echo "Creating ~/.tmux symlink..." 1>&5
	[[ -e ~/.tmux ]] && rm ~/.tmux
	ln -sf $top ~/.tmux
fi

# Create ~/.tmux.conf symlink
if [[ $current_tmux_conf != $top/tmux.conf ]]; then
	echo "Creating ~/.tmux.conf symlink..." 1>&5
	[[ -e ~/.tmux.conf ]] && mv ~/.tmux.conf ~/.tmux.conf.$now
	ln -sf $top/tmux.conf ~/.tmux.conf
fi

# Install plugins
echo "Installing tmux plugins..." 1>&5
_git submodule update --init --remote --recursive
tmux run-shell $top/plugins/tpm/bin/clean_plugins
tmux run-shell $top/plugins/tpm/bin/install_plugins
tmux run-shell "$top/plugins/tpm/bin/update_plugins all"

