#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq
# shellcheck shell=bash

set -eou pipefail

dirname="$(dirname "$0")"

updateHash()
{
    version=$1
    arch=$2
    os=$3

    hashKey="${arch}-${os}_hash"

    url="https://github.com/Prowlarr/Prowlarr/releases/download/v$version/Prowlarr.develop.$version.$os-core-$arch.tar.gz"
    hash=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix hash to-sri --type sha256 $hash)"

    sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$sriHash\";|g" "$dirname/default.nix"
}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/default.nix"
}

currentVersion=$(cd $dirname && nix eval --raw -f ../../.. prowlarr.version)

# N.B. Prowlarr is still in development, so
# https://api.github.com/repos/Prowlarr/Prowlarr/releases/latest
# returns nothing. Once this endpoint returns something, we should use
# it. Until then, we use jq to sort releases (N.B. the "sort_by(. |
# split(".") | map(tonumber))" incantation is to sort the version
# number properly and not as a string).

# latestTag=$(curl https://api.github.com/repos/Prowlarr/Prowlarr/releases/latest | jq -r ".tag_name")
# latestVersion="$(expr $latestTag : 'v\(.*\)')"
latestVersion=$(curl https://api.github.com/repos/Prowlarr/Prowlarr/git/refs/tags | jq '. | map(.ref | sub("refs/tags/v";"")) | sort_by(. | split(".") | map(tonumber)) | .[-1]' -r)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Prowlarr is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion $latestVersion

updateHash $latestVersion x64 linux
updateHash $latestVersion arm64 linux
updateHash $latestVersion x64 osx
