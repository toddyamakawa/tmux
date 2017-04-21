#!/bin/zsh
local here=${0:h}
which bjobs &> /dev/null || exit

source $here/colors.conf

red="#[fg=$tmux_red]"
yellow="#[fg=$tmux_yellow]"
green="#[fg=$tmux_green]"
blue="#[fg=$tmux_blue]"
white="#[fg=$tmux_white]"
comma="$blue,"

#jobs=$(bjobs -noheader -a -o stat)
jobs=$(cat $here/bjobs.txt)

string=$blue'['
string+=$green$( echo $jobs | grep -c RUN )$comma
string+=$yellow$(echo $jobs | grep -c PEND)$comma
string+=$white$( echo $jobs | grep -c DONE)$comma
string+=$red$(   echo $jobs | grep -c EXIT)$blue']'
echo $string

