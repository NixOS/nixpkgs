#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts
#shellcheck shell=bash

set -eu -o pipefail

version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/mockoon/mockoon/releases/latest | jq -e -r .tag_name)
# remove 'v' prefix
version="${version#v}"

pname=$(nix-instantiate --eval -A mockoon.pname)
# remove surrounding double quoutes
pname="${pname//\"}"
# extract version from pname
old_version=$(awk -F'-' '{print $NF}' <<< "${pname}")

if [[ $version == "$old_version" ]]; then
    echo "New version same as old version, nothing to do." >&2
    exit 0
fi

script_dir=$(dirname "$0")
sed -i "s/version = \"${old_version}\";/version = \"${version}\";/" "${script_dir}/default.nix"
