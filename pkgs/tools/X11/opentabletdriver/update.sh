#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq common-updater-scripts
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

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
$(nix-build -A opentabletdriver.fetch-deps --no-out-link)
