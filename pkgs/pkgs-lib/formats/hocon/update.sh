#!/usr/bin/env nix-shell
#!nix-shell -p cargo -i bash
cd "$(dirname "$0")"
cargo update
