#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq coreutils gawk

#common-updater-scripts

set -Eeuo pipefail # TODO: -E needed?

json=$(curl -s 'https://redstone-launcher.mojang.com/release/v2/products/launcher/75c4b4bddedcc2b1b10af1a720b8dc7a9a18c8d4/linux.json' | jq -r '.bootstrap')
version=$(jq -r '.version.name' <<< $json)

manifest=$(curl -s $(jq -r '.manifest.url' <<< $json))
sha1=$(jq -r '.files."minecraft-launcher".downloads.raw.sha1' <<< $manifest)
url=$(jq -r '.files."minecraft-launcher".downloads.raw.url' <<< $manifest)


# Get Nar hash, because flat hash mode doesn't work for executables
t=$(mktemp -d)
trap "rm -r $t" EXIT # TODO: is this safe? is there some edge case where this will delete something important?

curl -s $url -o $t/minecraft-launcher
chmod +x $t/minecraft-launcher
[ x$(sha1sum $t/minecraft-launcher | awk '{ print $1 }') = x$sha1 ] || (echo >&2 "SHA1 sum incorrect! This is bad!"; exit 1)

hash=$(nix --extra-experimental-features nix-command hash path $t/minecraft-launcher)


echo "{\"version\": \"$version\",\"url\": \"$url\",\"hash\": \"$hash\"}" > version.json
