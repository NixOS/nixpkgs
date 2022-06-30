#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../. -i bash -p curl jq common-updater-scripts nuget-to-nix dotnet-sdk
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

if [[ "$1" != "--deps-only" ]]; then
    update-source-version osu-lazer "$new_version"
fi

store_src="$(nix-build . -A osu-lazer.src --no-out-link)"
src="$(mktemp -d /tmp/osu-src.XXX)"
echo "Temp src dir: $src"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

export DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

mkdir ./nuget_tmp.packages
dotnet --info
dotnet restore osu.Desktop --packages ./nuget_tmp.packages --runtime linux-x64

nuget-to-nix ./nuget_tmp.packages > "$deps_file"

popd
rm -r "$src"
