#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq

set -e

dirname="$(dirname "$0")"

updateHash()
{
    version=$1
    arch=$2
    os=$3

    hashKey="${arch}-${os}_hash"

    url="https://github.com/Sonarr/Sonarr/releases/download/v${version}/Sonarr.main.${version}.${os}-${arch}.tar.gz";
    hash=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix hash to-sri --type sha256 $hash)"

    sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$sriHash\";|g" "$dirname/default.nix"
}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/default.nix"
}

currentVersion=$(cd $dirname && nix eval --raw -f ../../.. sonarr.version)

latestTag=$(curl https://api.github.com/repos/Sonarr/Sonarr/releases/latest | jq -r ".tag_name")
latestVersion="$(expr $latestTag : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Sonarr is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion $latestVersion

updateHash $latestVersion x64 linux
updateHash $latestVersion arm64 linux
updateHash $latestVersion x64 osx
updateHash $latestVersion arm64 osx
