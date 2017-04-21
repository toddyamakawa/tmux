#!/bin/zsh
local here=${0:h}
which bjobs &> /dev/null || exit

red="#[fg=colour9]"
yellow="#[fg=colour11]"
green="#[fg=colour82]"
blue="#[fg=colour33]"
white="#[fg=colour15]"
comma="$blue,"

#jobs=$(bjobs -noheader -a -o stat)
jobs=$(cat $here/bjobs.txt)

string=$blue'['
string+=$green$( echo $jobs | grep -c RUN )$comma
string+=$yellow$(echo $jobs | grep -c PEND)$comma
string+=$white$( echo $jobs | grep -c DONE)$comma
string+=$red$(   echo $jobs | grep -c EXIT)$blue']'
echo $string

