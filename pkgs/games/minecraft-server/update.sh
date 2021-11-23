#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

BASEDIR="$(dirname "$0")"

# get current release version
versions=$(curl -s 'https://launchermeta.mojang.com/mc/game/version_manifest.json')
version=$(echo $versions | jq .latest.release)
url=$(echo $versions | jq -r ".versions[] | select(.id == $version) | .url")

# get current server.jar
versions=$(curl -s $url | jq .downloads.server)
sha1=$(echo $versions | jq .sha1)
url=$(echo $versions | jq .url)

echo $version: $url:$sha1

# change default.nix
sed -i "s/version = \"[0-9.]*\";/version = ${version};/g" "$BASEDIR/default.nix"
sed -i "s+url = \"[a-zA-Z0-9/:.]*/server.jar\";+url = $url;+g" "$BASEDIR/default.nix"
sed -i "s/sha1 = \"[a-zA-Z0-9]*\";/sha1 = ${sha1};/g" "$BASEDIR/default.nix"
