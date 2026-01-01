#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p nix wget jq nix-prefetch-github nurl
=======
#!nix-shell -i bash -p nix wget jq nix-prefetch
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

# shellcheck shell=bash

if [ -n "$GITHUB_TOKEN" ]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

if [[ $# -gt 1 || $1 == -* ]]; then
    echo "Regenerates packaging data for the woodpecker packages."
    echo "Usage: $0 [git release tag]"
    exit 1
fi

<<<<<<< HEAD
=======
cd "$(dirname "$0")"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
version="$1"

set -euo pipefail

<<<<<<< HEAD
NIXPKGS_ROOT="$(git rev-parse --show-toplevel)"

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
if [ -z "$version" ]; then
    version="$(wget -q -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/woodpecker-ci/woodpecker/releases?per_page=10" | jq -r '[.[] | select(.prerelease == false)][0].tag_name')"
fi

# strip leading "v"
version="${version#v}"
<<<<<<< HEAD
rev="v$version"

cd "$(dirname "$0")"

# Woodpecker repository source hash
src_hash=$(nix-prefetch-github woodpecker-ci woodpecker --rev "$rev" | jq -r .hash)
sed -i -E -e "s#hash = \".*\"#hash = \"$src_hash\"#" common.nix
sed -i -E -e "s#version = \".*\"#version = \"$version\"#" common.nix

# Go modules vendor hash
vendor_hash=$(nurl -e "(import $NIXPKGS_ROOT/. { }).woodpecker-server.goModules")
sed -i -E -e "s#vendorHash = \".*\"#vendorHash = \"$vendor_hash\"#" common.nix

# pnpm dependencies hash for web UI
pnpm_hash=$(nurl -e "(import $NIXPKGS_ROOT/. { }).woodpecker-server.pnpmDeps")
sed -i -E -e "s#nodeModulesHash = \".*\"#nodeModulesHash = \"$pnpm_hash\"#" common.nix

echo "Update complete!"
echo "Version: $version"
echo "Source hash: $src_hash"
echo "go vendor hash: $vendor_hash"
echo "pnpm dependencies hash: $pnpm_hash"
=======
sed -i -E -e "s#version = \".*\"#version = \"$version\"#" common.nix

# Woodpecker repository
src_hash=$(nix-prefetch-url --type sha256 --unpack "https://github.com/woodpecker-ci/woodpecker/releases/download/v$version/woodpecker-src.tar.gz")
src_hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$src_hash")
sed -i -E -e "s#srcHash = \".*\"#srcHash = \"$src_hash\"#" common.nix
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
