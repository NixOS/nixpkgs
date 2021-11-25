#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts

set -eu -o pipefail

version="$(curl https://download.jitsi.org/stable/ | \
    pup 'a[href] text{}' | \
    awk -F'[_-]' '/jitsi-meet-prosody/ {printf $4"\n"}' | \
    sort -u | \
    tail -n 1)"

update-source-version jitsi-meet-prosody "$version"
