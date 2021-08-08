#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts dotnet-sdk_5
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

echo "{ fetchNuGet }: [" >"$deps_file"
while read pkg_spec; do
  { read pkg_name; read pkg_version; } < <(
    # Build version part should be ignored: `3.0.0-beta2.20059.3+77df2220` -> `3.0.0-beta2.20059.3`
    sed -nE 's/.*<id>([^<]*).*/\1/p; s/.*<version>([^<+]*).*/\1/p' "$pkg_spec")
  pkg_sha256="$(nix-hash --type sha256 --flat --base32 "$(dirname "$pkg_spec")"/*.nupkg)"
  cat >>"$deps_file" <<EOF
  (fetchNuGet {
    name = "$pkg_name";
    version = "$pkg_version";
    sha256 = "$pkg_sha256";
  })
EOF
done < <(find ./nuget_tmp.packages -name '*.nuspec' | sort)
echo "]" >>"$deps_file"

popd
rm -r "$src"
