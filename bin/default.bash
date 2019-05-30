#!/usr/bin/env bash
declare -r CURRENT_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
declare -r TMUX_VERSION=$(tmux -V | cut -c 6-8)

default_file="$HOME/.tmux/key-bindings/default-$TMUX_VERSION.conf"
cat > $default_file << EOM
# vi: filetype=tmux

# --- Remove All Key Bindings ---
unbind-key -a

EOM
tmux list-keys >> "$default_file"


