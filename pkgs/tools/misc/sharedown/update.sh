#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq yarn yarn2nix-moretea.yarn2nix

set -euo pipefail

owner=kylon
repo=Sharedown
latestVersion=$(curl "https://api.github.com/repos/$owner/$repo/releases/latest" | jq -r '.tag_name')
currentVersion=$(nix-instantiate --eval --expr 'with import ./. {}; sharedown.version' | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" && "${BUMP_LOCK-}" != "1" ]]; then
    # Skip update when already on the latest version.
    exit 0
fi

update-source-version sharedown "$latestVersion"

dirname="$(realpath "$(dirname "$0")")"
sourceDir="$(nix-build -A sharedown.src --no-out-link)"
tempDir="$(mktemp -d)"

cp -r "$sourceDir"/* "$tempDir"
cd "$tempDir"
PUPPETEER_SKIP_DOWNLOAD=1 yarn install
yarn2nix > "$dirname/yarndeps.nix"
cp -r yarn.lock "$dirname"
