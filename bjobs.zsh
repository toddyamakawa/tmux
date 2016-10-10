#!/bin/zsh

red="#[fg=colour9]"
yellow="#[fg=colour11]"
green="#[fg=colour82]"
blue="#[fg=colour33]"
white="#[fg=colour15]"
comma="$blue,"

jobs=$(bjobs -noheader -a -o stat)
done=$white$(echo $jobs | grep -c DONE)
exit=$red$(echo $jobs | grep -c EXIT)
pend=$yellow$(echo $jobs | grep -c PEND)
run=$green$(echo $jobs | grep -c RUN)

string=$run$comma
string+=$pend$comma
string+=$done$comma
string+=$exit$blue
echo $string

