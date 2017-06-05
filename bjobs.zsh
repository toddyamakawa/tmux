#!/bin/zsh
local here=${0:h}
which bjobs &> /dev/null || return

# Generate bjobs.txt
[[ -f $here/bjobs.txt ]] || touch $here/bjobs.txt
age=$(($(date +%s)-$(stat -c %Y $here/bjobs.txt)))
[[ $age -lt 300 ]] && bjobs -noheader -a -o stat > $here/bjobs.txt

# Get job information from bjobs.txt
#[[ -s $here/bjobs.txt ]] || return
grep "No job found" $here/bjobs.txt && return
jobs=$(cat $here/bjobs.txt)

# tmux colors and characters
source $here/colors.conf
red="#[fg=$tmux_red]"
yellow="#[fg=$tmux_yellow]"
green="#[fg=$tmux_green]"
blue="#[fg=$tmux_blue]"
white="#[fg=$tmux_white]"
comma="$blue,"

# Print tmux job string
string=$blue'['
string+=$green$( echo $jobs | grep -c RUN )$comma
string+=$yellow$(echo $jobs | grep -c PEND)$comma
string+=$white$( echo $jobs | grep -c DONE)$comma
string+=$red$(   echo $jobs | grep -c EXIT)$blue']'
echo $string

