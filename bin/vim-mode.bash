#!/usr/bin/env bash
pane_file=$(mktemp)
tmux capture-pane -p -S - | \
	sed \
		-e 's/.*/\n\$> /' \
		-e '/^\[.*\] \(Starting timer\|Execution time\)/d' \
		-e '/^Exit code/d' \
	> $pane_file

vim $pane_file
rm $pane_file

