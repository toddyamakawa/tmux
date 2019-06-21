#!/usr/bin/env bash
session=${1-$(tmux display-message -p "#{session_name}")}
declare -r now=$(date +%Y%m%d-%H%M%S-Week%U-%a-%T)
declare -r backup_dir=$HOME/.tmux/save/$session
declare -r backup_file=$backup_dir/$now.tmux

# Save tmux panes in target session to .tmux file
tab=$'\t'
mkdir -p $backup_dir
pane_format="#{window_index}$tab#{window_name}$tab#{pane_current_path}"
tmux list-panes -F "$pane_format" -s -t $session > $backup_file

