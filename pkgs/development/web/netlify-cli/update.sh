#!/usr/bin/env nix-shell
#!nix-shell -i bash
set -euo pipefail
mv netlify-cli.json{,.old}
nix-prefetch-github-latest-release netlify cli >netlify-cli.json

if ! diff -U3 netlify-cli.json{.old,}; then
    echo New version detected\; generating expressions...
    ./generate.sh
fi
rm -f netlify-cli.json.old
