#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p common-updater-scripts
# shellcheck shell=bash

set -euo pipefail

pname=$1
old_version=$2
url=$3

cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

new_version="$(list-git-tags --url="$url" | sort --reverse --numeric-sort | head -n 1)"

if [[ "$new_version" == "$old_version" ]]; then
    echo "Already up to date!"
    exit 0
fi

updateVersion() {
    sed -i "s/version = \"$old_version\";/version = \"$new_version\";/g" default.nix
}

updateHash() {
    hashKey="hash"
    hash=$(nix-prefetch-url --unpack --type sha256 "$url/archive/$new_version.tar.gz")
    sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$hash\";|g" default.nix
}

updateVersion
updateHash

cd ../../../../../

$(nix-build -A "$pname".fetch-deps --no-out-link) "$deps_file"
