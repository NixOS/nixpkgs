#!/bin/sh

_base="$HOME/.local/share/slipstream"

mkdir -p "$_base"
mkdir "$_base/mods" # FIX: slipstream needs mods dir to exist
mkdir "$_base/backup"

cd "$_base"

java -jar "$jar_file"
