#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts
# shellcheck shell=bash

set -eu -o pipefail

version="$(curl https://download.jitsi.org/stable/ | \
    pup 'a[href] text{}' | \
    awk -F'[_-]' '/jicofo/ {printf $2"-"$3"\n"}' | \
    sort -u | \
    tail -n 1)"

update-source-version jicofo "$version"
