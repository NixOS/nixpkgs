#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq common-updater-scripts nuget-to-nix dotnet-sdk_6 dotnet-sdk_5
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

new_version="$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/OpenTabletDriver/OpenTabletDriver/releases" | jq -r  'map(select(.prerelease == false)) | .[0].tag_name' | cut -c2-)"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date!"
  [[ "${1}" != "--force" ]] && exit 0
fi

# Updating the hash of deb package manually since there seems to be no way to do it automatically
oldDebPkgUrl="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${old_version}/OpenTabletDriver.deb";
newDebPkgUrl="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${new_version}/OpenTabletDriver.deb";
oldDebSha256=$(nix-prefetch-url "$oldDebPkgUrl")
newDebSha256=$(nix-prefetch-url "$newDebPkgUrl")
echo "oldDebSha256: $oldDebSha256 newDebSha256: $newDebSha256"
sed -i ./default.nix -re "s|\"$oldDebSha256\"|\"$newDebSha256\"|"

pushd ../../../..
update-source-version opentabletdriver "$new_version"
store_src="$(nix-build -A opentabletdriver.src --no-out-link)"
src="$(mktemp -d /tmp/opentabletdriver-src.XXX)"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"
trap "rm -rf $src" EXIT

export DOTNET_NOLOGO=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

mkdir ./nuget_pkgs
for project in OpenTabletDriver.{Console,Daemon,UX.Gtk,Tests}; do
  dotnet restore $project --packages ./nuget_pkgs
done

nuget-to-nix ./nuget_pkgs > "$deps_file"
