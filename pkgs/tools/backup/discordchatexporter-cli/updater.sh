#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts nuget-to-nix dotnet-sdk_5
# shellcheck shell=bash
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

new_version="$(curl -s "https://api.github.com/repos/tyrrrz/DiscordChatExporter/releases?per_page=1" | jq -r '.[0].name')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"
if [[ "$new_version" == "$old_version" ]]; then
  echo "Up to date"
  exit 0
fi

cd ../../../..
update-source-version discordchatexporter-cli "$new_version"
store_src="$(nix-build . -A discordchatexporter-cli.src --no-out-link)"
src="$(mktemp -d /tmp/discordexporter-src.XXX)"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

mkdir ./nuget_tmp.packages
dotnet restore DiscordChatExporter.Cli/DiscordChatExporter.Cli.csproj --packages ./nuget_tmp.packages

nuget-to-nix ./nuget_tmp.packages > "$deps_file"

popd
rm -r "$src"
