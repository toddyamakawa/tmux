#!/bin/bash

for i in $(seq 0 31); do
	for j in $(seq 0 7); do
		k=$(expr 8 \* $i + $j)
		printf "\x1b[38;5;${k}mcolour%-3d " $k
	done
	printf '\n'
done

