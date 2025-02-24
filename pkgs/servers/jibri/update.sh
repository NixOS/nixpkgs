#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts

set -eu -o pipefail

version="$(curl https://download.jitsi.org/stable/ | \
    pup 'a[href] text{}' | \
    awk -F'[_-]' '/jibri/ {printf $2"-"$3"-"$4"\n"}' | \
    sort -Vu | \
    tail -n 1)"

update-source-version jibri "$version"
