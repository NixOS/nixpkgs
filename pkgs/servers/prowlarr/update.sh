#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq

set -eou pipefail

dirname="$(dirname "$0")"

updateHash()
{
    # nixos
    version=$1
    system=$2

    # prowlarr
    arch=$3
    os=$4

    url="https://github.com/Prowlarr/Prowlarr/releases/download/v$version/Prowlarr.master.$version.$os-core-$arch.tar.gz"
    hash=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix hash to-sri --type sha256 $hash)"

    sed -i "s|$system = \"sha256-[a-zA-Z0-9\/+-=]*\";|$system = \"$sriHash\";|g" "$dirname/default.nix"
}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/default.nix"
}

currentVersion=$(cd $dirname && nix eval --raw -f ../../.. prowlarr.version)

latestTag=$(curl https://api.github.com/repos/Prowlarr/Prowlarr/releases/latest | jq -r ".tag_name")
latestVersion="$(expr $latestTag : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Prowlarr is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion $latestVersion

updateHash $latestVersion aarch64-darwin arm64 osx
updateHash $latestVersion aarch64-linux arm64 linux
updateHash $latestVersion x86_64-darwin x64 osx
updateHash $latestVersion x86_64-linux x64 linux
