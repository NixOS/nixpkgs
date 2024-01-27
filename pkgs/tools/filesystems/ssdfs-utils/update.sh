#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep common-updater-scripts
set -euo pipefail

owner=dubeyko
repo=ssdfs-tools

version="$(curl --silent https://raw.githubusercontent.com/${owner}/${repo}/master/configure.ac | \
    grep 'AC_INIT(ssdfs' | \
    egrep -o '[0-9\.]{3,}')"

rev=$(curl -s -H "Accept: application/vnd.github.VERSION.sha" https://api.github.com/repos/${owner}/${repo}/commits/master)

update-source-version ssdfs-utils "$version" --rev="$rev"
