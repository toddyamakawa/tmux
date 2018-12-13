#!/usr/bin/env bash
declare -r tmux_dir=$HOME/.tmux
declare -r remote_root_conf=$tmux_dir/key-bindings/remote.generated.conf

if [[ ! -f $remote_root_conf ]]; then
	tmux list-keys -T root | \
		awk '{print "bind-key -n "$4" send-keys "$4}' > \
		$remote_root_conf
fi
tmux source-file $remote_root_conf
tmux source-file $remote_root_conf
tmux source-file $tmux_dir/key-bindings/remote.conf
tmux source-file $tmux_dir/theme/remote.black.conf

