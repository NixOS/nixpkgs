#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nuget-to-nix dotnet-sdk_5
# shellcheck shell=bash
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

new_version="$(curl -s "https://api.github.com/repos/ppy/osu/releases?per_page=1" | jq -r '.[0].name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"
if [[ "$new_version" == "$old_version" ]]; then
  echo "Up to date"
  exit 0
fi

cd ../../..
update-source-version osu-lazer "$new_version"
store_src="$(nix-build . -A osu-lazer.src --no-out-link)"
src="$(mktemp -d /tmp/osu-src.XXX)"
echo "Temp src dir: $src"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

mkdir ./nuget_tmp.packages
dotnet restore osu.Desktop --packages ./nuget_tmp.packages --runtime linux-x64

nuget-to-nix ./nuget_tmp.packages > "$deps_file"

popd
rm -r "$src"
