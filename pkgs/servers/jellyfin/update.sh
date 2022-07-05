#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts dotnetCorePackages.sdk_6_0 nuget-to-nix gnused nix coreutils findutils

set -euo pipefail

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1

latestVersion="$(curl -s "https://api.github.com/repos/jellyfin/jellyfin/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; jellyfin.version or (lib.getVersion jellyfin)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "jellyfin is up-to-date: $currentVersion"
  exit 0
fi

pushd "$(dirname "${BASH_SOURCE[0]}")"
nugetDepsFile=$(realpath ./nuget-deps.nix)
popd

update-source-version jellyfin "$latestVersion"

store_src="$(nix-build . -A jellyfin.src --no-out-link)"
src="$(mktemp -d /tmp/jellyfin-src.XXX)"
echo "Temp src dir: $src"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

mkdir ./nuget_tmp.packages

dotnet restore Jellyfin.Server --packages ./nuget_tmp.packages --runtime linux-x86
dotnet restore Jellyfin.Server --packages ./nuget_tmp.packages --runtime linux-x64
dotnet restore Jellyfin.Server --packages ./nuget_tmp.packages --runtime linux-arm
dotnet restore Jellyfin.Server --packages ./nuget_tmp.packages --runtime linux-arm64

nuget-to-nix ./nuget_tmp.packages > "$nugetDepsFile"

popd
rm -r "$src"
