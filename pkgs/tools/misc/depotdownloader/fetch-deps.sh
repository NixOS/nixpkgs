#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nuget-to-nix dotnet-sdk_5
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

cd ../../../..
store_src="$(nix-build . -A depotdownloader.src --no-out-link)"
src="$(mktemp -d /tmp/depotdownloader-src.XXX)"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

mkdir ./nuget_tmp.packages
dotnet restore DepotDownloader.sln --packages ./nuget_tmp.packages

nuget-to-nix ./nuget_tmp.packages > "$deps_file"

popd
rm -r "$src"
