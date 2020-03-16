#!/bin/sh
nix eval -f test-evaluation.nix "$1" > "$1"
sed -i "$1" -e 's/\[ //g' -e 's/ ]//g' -e 's/ /\n/g' -e 's/\"//g'  

