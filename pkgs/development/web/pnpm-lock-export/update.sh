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
rev="$1"

set -euo pipefail

if [ -z "$rev" ]; then
    rev="$(wget -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/adamcstephens/pnpm-lock-export/commits?per_page=1" | jq -r '.[0].sha')"
fi

# pnpm-lock-export repository
src_hash=$(nix-prefetch-github adamcstephens pnpm-lock-export --rev "${rev}" | jq -r .hash)

# Front-end dependencies
upstream_src="https://raw.githubusercontent.com/adamcstephens/pnpm-lock-export/${rev}"

trap 'rm -rf package.json' EXIT
wget "${TOKEN_ARGS[@]}" "$upstream_src/package.json"
npm install --package-lock-only
deps_hash=$(prefetch-npm-deps package-lock.json)

# Use friendlier hashes
deps_hash=$(nix hash to-sri --type sha256 "$deps_hash")

sed -i -E -e "s#rev = \".*\"#rev = \"$rev\"#" default.nix
sed -i -E -e "s#hash = \".*\"#hash = \"$src_hash\"#" default.nix
sed -i -E -e "s#npmDepsHash = \".*\"#npmDepsHash = \"$deps_hash\"#" default.nix
