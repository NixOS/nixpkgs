#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq

set -euo pipefail

DIRNAME=$(dirname "$0")
readonly DIRNAME
readonly NIXPKGS_ROOT="../../../.."
readonly NIX_FLAGS=(--extra-experimental-features 'nix-command flakes')

updateHash()
{
    local -r version="${1//./}"
    local -r arch="$2"
    local -r os="$3"
    local -r nix_arch="$4"

    url="https://www.rarlab.com/rar/rar$os-$arch-$version.tar.gz"
    hash=$(nix store prefetch-file --json "$url" | jq -r .hash)
    currentHash=$(cd "$DIRNAME" && nix "${NIX_FLAGS[@]}" eval --raw "$NIXPKGS_ROOT#legacyPackages.$nix_arch.rar.src.outputHash")

    sed -i "s|$currentHash|$hash|g" "$DIRNAME/default.nix"
}

updateVersion()
{
    local -r version="$1"
    sed -i "s|version = \"[0-9.]*\";|version = \"$version\";|g" "$DIRNAME/default.nix"
}

# TODO: get latest version
readonly latestVersion="${1:-}"

if [[ -z "$latestVersion" ]]; then
    echo "usage: $0 <version to update>"
    exit 1
fi

currentVersion=$(cd "$DIRNAME" && nix "${NIX_FLAGS[@]}" eval --raw "$NIXPKGS_ROOT#legacyPackages.x86_64-linux.rar.version")
readonly currentVersion

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "rar is up-to-date: ${currentVersion}"
    exit 0
fi

updateHash "$latestVersion" x32 linux i686-linux
updateHash "$latestVersion" x64 linux x86_64-linux
updateHash "$latestVersion" arm macos aarch64-darwin
updateHash "$latestVersion" x64 macos x86_64-darwin

updateVersion "$latestVersion"
