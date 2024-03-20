#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl prefetch-yarn-deps nix-prefetch-github

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

latest=$(curl -s https://api.github.com/repos/stashapp/stash/tags | jq '.[0]')
version="$(expr $(echo $latest | jq -r .name) : 'v\(.*\)')"
gitHash="$(echo $latest | jq -r '.commit.sha' | cut -c1-8)"

srcHash=$(nix-prefetch-github stashapp stash --rev v${version} | jq -r .hash)

curl -s "https://raw.githubusercontent.com/stashapp/stash/v${version}/ui/v2.5/yarn.lock" --output yarn.lock
yarnHash=$(prefetch-yarn-deps yarn.lock)
yarnHash=$(nix hash to-sri --type sha256 "$yarnHash")
rm -f yarn.lock

echo "version = \"$version\";"
echo "gitHash = \"$gitHash\";"
echo "srcHash = \"$srcHash\";"
echo "yarnHash = \"$yarnHash\";"

sed -i -E -e "s#version = \".*\"#version = \"$version\"#" default.nix
sed -i -E -e "s#gitHash = \".*\"#gitHash = \"$gitHash\"#" default.nix
sed -i -E -e "s#srcHash = \".*\"#srcHash = \"$srcHash\"#" default.nix
sed -i -E -e "s#yarnHash = \".*\"#yarnHash = \"$yarnHash\"#" default.nix
