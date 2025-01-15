#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts gnused nix coreutils
#shellcheck shell=bash

set -euo pipefail

latestVersion=$(curl -s ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/recyclarr/recyclarr/releases?per_page=1 \
    | jq -r ".[0].tag_name" \
    | sed 's/^v//')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; recyclarr.version or (lib.getVersion recyclarr)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "recyclarr is up-to-date: $currentVersion"
    exit 0
fi

function get_hash() {
    local os=$1
    local arch=$2
    local version=$3

    local pkg_hash=$(nix-prefetch-url --type sha256 \
        https://github.com/recyclarr/recyclarr/releases/download/v"${version}"/recyclarr-"${os}"-"${arch}".tar.xz)
    nix hash to-sri "sha256:$pkg_hash"
}

# aarch64-darwin
# reset version first so that all platforms are always updated and in sync
update-source-version recyclarr 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" --system="aarch64-darwin"
update-source-version recyclarr "$latestVersion" $(get_hash osx arm64 "$latestVersion") --system="aarch64-darwin"

# x86_64-darwin
# reset version first so that all platforms are always updated and in sync
update-source-version recyclarr 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" --system="x86_64-darwin"
update-source-version recyclarr "$latestVersion" $(get_hash osx x64 "$latestVersion") --system="x86_64-darwin"

# aarch64-linux
# reset version first so that all platforms are always updated and in sync
update-source-version recyclarr 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" --system="aarch64-linux"
update-source-version recyclarr "$latestVersion" $(get_hash linux arm64 "$latestVersion") --system="aarch64-linux"

# x86_64-linux
# reset version first so that all platforms are always updated and in sync
update-source-version recyclarr 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" --system="x86_64-linux"
update-source-version recyclarr "$latestVersion" $(get_hash linux x64 "$latestVersion") --system="x86_64-linux"

