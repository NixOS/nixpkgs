#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix wget nix-prefetch-github jq prefetch-npm-deps nodejs

# shellcheck shell=bash

if [ -n "$GITHUB_TOKEN" ]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

if [[ $# -gt 1 || $1 == -* ]]; then
    echo "Regenerates packaging data for the pnpm-lock-export packages."
    echo "Usage: $0 [git release tag]"
    exit 1
fi

set -x

cd "$(dirname "$0")"
version="$1"

set -euo pipefail

if [ -z "$version" ]; then
    version="$(wget -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/cvent/pnpm-lock-export/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

# strip leading "v"
version="${version#v}"

# pnpm-lock-export repository
src_hash=$(nix-prefetch-github cvent pnpm-lock-export --rev "v${version}" | jq -r .sha256)

# Front-end dependencies
upstream_src="https://raw.githubusercontent.com/cvent/pnpm-lock-export/v$version"

trap 'rm -rf package.json' EXIT
wget "${TOKEN_ARGS[@]}" "$upstream_src/package.json"
npm install --package-lock-only
deps_hash=$(prefetch-npm-deps package-lock.json)

# Use friendlier hashes
src_hash=$(nix hash to-sri --type sha256 "$src_hash")
deps_hash=$(nix hash to-sri --type sha256 "$deps_hash")

sed -i -E -e "s#version = \".*\"#version = \"$version\"#" default.nix
sed -i -E -e "s#hash = \".*\"#hash = \"$src_hash\"#" default.nix
sed -i -E -e "s#npmDepsHash = \".*\"#npmDepsHash = \"$deps_hash\"#" default.nix
