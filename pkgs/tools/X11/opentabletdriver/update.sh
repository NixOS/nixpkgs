#!/usr/bin/env nix-shell
#!nix-shell shell.nix -i bash

set -eo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

new_version="$(curl -s "https://api.github.com/repos/OpenTabletDriver/OpenTabletDriver/releases" | jq -r '.[0].tag_name' | sed 's|[^0-9.]||g')"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"
if [[ "$new_version" == "$old_version" ]]; then
  echo "Up to date"
  [[ "${1}" != "--force" ]] && exit 0
fi

# Updating the hash of deb package manually since there seems to be no way to do it automatically
oldDebPkgUrl="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${old_version}/OpenTabletDriver.deb";
newDebPkgUrl="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${new_version}/OpenTabletDriver.deb";
oldDebSha256=$(nix-prefetch-url "$oldDebPkgUrl")
newDebSha256=$(nix-prefetch-url "$newDebPkgUrl")
echo "oldDebSha256: $oldDebSha256 newDebSha256: $newDebSha256"
sed -i ./default.nix -re "s|\"$oldDebSha256\"|\"$newDebSha256\"|"

cd ../../../..
update-source-version opentabletdriver "$new_version"
store_src="$(nix-build . -A opentabletdriver.src --no-out-link)"
src="$(mktemp -d /tmp/opentabletdriver-src.XXX)"
echo "Temp src dir: $src"
cp -rT "$store_src" "$src"
chmod -R +w "$src"

pushd "$src"

# Setup empty nuget package folder to force reinstall.
mkdir ./nuget_tmp.packages
cat >./nuget_tmp.config <<EOF
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <add key="nuget" value="https://api.nuget.org/v3/index.json" />
  </packageSources>
  <config>
    <add key="globalPackagesFolder" value="$(realpath ./nuget_tmp.packages)" />
  </config>
</configuration>
EOF

export DOTNET_CLI_TELEMETRY_OPTOUT=1

for project in OpenTabletDriver.{Console,Daemon,UX.Gtk}; do
    dotnet restore $project --configfile ./nuget_tmp.config
done

nuget-to-nix ./nuget_tmp.packages > "$deps_file"

popd
rm -r "$src"
