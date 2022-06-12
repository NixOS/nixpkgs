#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch libarchive
# shellcheck shell=bash
set -euo pipefail
cd "$(dirname "$0")"
owner=rust-lang
repo=rust-analyzer
nixpkgs=../../../../..

# Update lsp

ver=$(
    curl -s "https://api.github.com/repos/$owner/$repo/releases" |
    jq 'map(select(.prerelease | not)) | .[0].tag_name' --raw-output
)
old_ver=$(sed -nE 's/.*\bversion = "(.*)".*/\1/p' ./default.nix)
if grep -q 'cargoSha256 = ""' ./default.nix; then
    old_ver='broken'
fi
if [[ "$ver" == "$old_ver" ]]; then
    echo "Up to date: $ver"
    exit
fi
echo "$old_ver -> $ver"

sha256=$(nix-prefetch -f "$nixpkgs" rust-analyzer-unwrapped.src --rev "$ver")
# Clear cargoSha256 to avoid inconsistency.
sed -e "s#version = \".*\"#version = \"$ver\"#" \
    -e "/fetchFromGitHub/,/}/ s#sha256 = \".*\"#sha256 = \"$sha256\"#" \
    -e "s#cargoSha256 = \".*\"#cargoSha256 = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\"#" \
    --in-place ./default.nix

echo "Prebuilding for cargoSha256"
cargo_sha256=$(nix-prefetch "{ sha256 }: (import $nixpkgs {}).rust-analyzer-unwrapped.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
sed "s#cargoSha256 = \".*\"#cargoSha256 = \"$cargo_sha256\"#" \
    --in-place ./default.nix
