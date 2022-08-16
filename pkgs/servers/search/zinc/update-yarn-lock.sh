#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq ripgrep yarn

set -euxo pipefail


dir="$(realpath $(dirname "$0"))"
version=$(cat default.nix | rg '^  version = "' | cut -d '"' -f 2)
checkout=$(mktemp -d)

git clone -b "v$version" --depth=1 https://github.com/zinclabs/zinc "$checkout"
cd "$checkout"

cd web
yarn import # convert the existing package-lock.json to yarn.lock
cp yarn.lock "$dir/yarn.lock"
