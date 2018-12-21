#!/usr/bin/env bash
# Prints all 256 colors
for row in $(seq 0 31); do
	for col in $(seq 0 7); do
		number=$(expr 8 \* $row + $col)
		printf "\x1b[38;5;${number}mcolour%-3d " $number
	done
	printf '\n'
done
