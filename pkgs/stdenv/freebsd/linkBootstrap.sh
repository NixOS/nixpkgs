#!/usr/bin/env bash

for path in $paths; do
    if ! [ -e "$src/$path" ]; then
        echo "Error: $path does not exist"
        exit 1
    fi
    mkdir -p $out/$(dirname $path)
    ln -s $src/$path $out/$path
done
