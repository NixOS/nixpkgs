#!/usr/bin/env bash

for path in $paths; do
    mkdir -p $out/$(dirname $path)
    ln -s $src/$path $out/$path
done
