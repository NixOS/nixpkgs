#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p nix wget prefetch-yarn-deps nix-prefetch-github jq nix-prefetch pnpm-lock-export
=======
#!nix-shell -i bash -p nix wget prefetch-yarn-deps nix-prefetch-github jq
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# shellcheck shell=bash

if [ -n "$GITHUB_TOKEN" ]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

if [[ $# -gt 1 || $1 == -* ]]; then
    echo "Regenerates packaging data for the woodpecker packages."
    echo "Usage: $0 [git release tag]"
    exit 1
fi

set -x

cd "$(dirname "$0")"
version="$1"

set -euo pipefail

if [ -z "$version" ]; then
    version="$(wget -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/woodpecker-ci/woodpecker/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

# strip leading "v"
version="${version#v}"

# Woodpecker repository
<<<<<<< HEAD
src_hash=$(nix-prefetch-github woodpecker-ci woodpecker --rev "v${version}" | jq -r .hash)

# Go modules
vendorHash=$(nix-prefetch '{ sha256 }: (callPackage (import ./cli.nix) { }).goModules.overrideAttrs (_: { modHash = sha256; })')
=======
src_hash=$(nix-prefetch-github woodpecker-ci woodpecker --rev "v${version}" | jq -r .sha256)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# Front-end dependencies
woodpecker_src="https://raw.githubusercontent.com/woodpecker-ci/woodpecker/v$version"
wget "${TOKEN_ARGS[@]}" "$woodpecker_src/web/package.json" -O woodpecker-package.json

<<<<<<< HEAD
trap 'rm -rf pnpm-lock.yaml' EXIT
wget "${TOKEN_ARGS[@]}" "$woodpecker_src/web/pnpm-lock.yaml"
pnpm-lock-export --schema yarn.lock@v1
yarn_hash=$(prefetch-yarn-deps yarn.lock)

# Use friendlier hashes
src_hash=$(nix hash to-sri --type sha256 "$src_hash")
vendorHash=$(nix hash to-sri --type sha256 "$vendorHash")
yarn_hash=$(nix hash to-sri --type sha256 "$yarn_hash")

sed -i -E -e "s#version = \".*\"#version = \"$version\"#" common.nix
sed -i -E -e "s#srcHash = \".*\"#srcHash = \"$src_hash\"#" common.nix
sed -i -E -e "s#vendorHash = \".*\"#vendorHash = \"$vendorHash\"#" common.nix
sed -i -E -e "s#yarnHash = \".*\"#yarnHash = \"$yarn_hash\"#" common.nix
=======
web_tmpdir=$(mktemp -d)
trap 'rm -rf "$web_tmpdir"' EXIT
pushd "$web_tmpdir"
wget "${TOKEN_ARGS[@]}" "$woodpecker_src/web/yarn.lock"
yarn_hash=$(prefetch-yarn-deps yarn.lock)
popd

# Use friendlier hashes
src_hash=$(nix hash to-sri --type sha256 "$src_hash")
yarn_hash=$(nix hash to-sri --type sha256 "$yarn_hash")

sed -i -E -e "s#version = \".*\"#version = \"$version\"#" common.nix
sed -i -E -e "s#srcSha256 = \".*\"#srcSha256 = \"$src_hash\"#" common.nix
sed -i -E -e "s#yarnSha256 = \".*\"#yarnSha256 = \"$yarn_hash\"#" common.nix
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
