#!/usr/bin/env bash

# This script lists all the optional command-line tools that diffoscope can use
# (i.e. `diffoscope --list-tools`) but are missing from the Nix expression.

diffoscope=$(nix-build --no-out-link -E 'with import ./. {}; diffoscope.override { enableBloat = true; }')/bin/diffoscope

required=$($diffoscope --list-tools | \
    grep '^External-Tools-Required:' | \
    cut -d ' ' -f2- | \
    tr -d ,)

# Uber-hacky!
pathScript=$(cat $diffoscope | grep PATH)

export PATH=$(nix-build --no-out-link -A which)/bin
eval "$pathScript"

for tool in $required; do
    if ! which $tool >/dev/null 2>&1; then
        echo $tool
    fi
done | sort
