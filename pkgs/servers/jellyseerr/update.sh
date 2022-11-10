#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq yarn yarn2nix-moretea.yarn2nix

set -euo pipefail

owner=Fallenbagel
repo=jellyseerr
latestVersion=$(curl -s "https://api.github.com/repos/$owner/$repo/releases/latest" | jq -r '.tag_name')
currentVersion=$(nix-instantiate --eval --expr 'with import ./. {}; jellyseerr.version' | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" && "${BUMP_LOCK-}" != "1" ]]; then
    # Skip update when already on the latest version.
    exit 0
fi

update-source-version jellyseerr "$latestVersion"

dirname="$(realpath "$(dirname "$0")")"
curl -o "$dirname/package.json" -s "https://raw.githubusercontent.com/$owner/$repo/$latestVersion/package.json"
curl -o "$dirname/yarn.lock" -s "https://raw.githubusercontent.com/$owner/$repo/$latestVersion/yarn.lock"

yarn2nix --lockfile "$dirname/yarn.lock" > "$dirname/yarn.nix"
