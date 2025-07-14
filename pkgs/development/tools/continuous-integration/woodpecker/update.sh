#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix wget jq nix-prefetch

# shellcheck shell=bash

if [ -n "$GITHUB_TOKEN" ]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

if [[ $# -gt 1 || $1 == -* ]]; then
    echo "Regenerates packaging data for the woodpecker packages."
    echo "Usage: $0 [git release tag]"
    exit 1
fi

cd "$(dirname "$0")"
version="$1"

set -euo pipefail

if [ -z "$version" ]; then
    version="$(wget -q -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/woodpecker-ci/woodpecker/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

# strip leading "v"
version="${version#v}"
sed -i -E -e "s#version = \".*\"#version = \"$version\"#" common.nix

# Woodpecker repository
src_hash=$(nix-prefetch-url --type sha256 --unpack "https://github.com/woodpecker-ci/woodpecker/releases/download/v$version/woodpecker-src.tar.gz")
src_hash=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$src_hash")
sed -i -E -e "s#srcHash = \".*\"#srcHash = \"$src_hash\"#" common.nix
