#!/usr/bin/env bash
pane_id=${1:-$(tmux display-message -p "#{pane_id}")}
pane_file=$(mktemp)
tmux capture-pane -t $pane_id -p -S - | \
	sed \
		-e 's/.*/\n\$> /' \
		-e '/^\[.*\] \(Starting timer\|Execution time\)/d' \
		-e '/^Exit code/d' \
	> $pane_file

vim $pane_file
rm $pane_file

