#!/usr/bin/env bash
declare -r tmux_dir=$HOME/.tmux
declare -r remote_root_conf=$tmux_dir/key-bindings/remote.generated.conf

# Generate config file
if [[ ! -f $remote_root_conf ]]; then
	tmux list-keys -T root | \
		awk '{print "bind-key -n "$4" send-keys "$4}' > \
		$remote_root_conf
	echo "source-file $tmux_dir/key-bindings/remote.conf" >> $remote_root_conf
	echo "run-shell '$tmux_dir/bin/colorscheme.zsh black'" >> $remote_root_conf
fi

# Source config file
tmux source-file $remote_root_conf

