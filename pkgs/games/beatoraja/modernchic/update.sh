#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nodejs common-updater-scripts

set -euo pipefail

package=beatoraja.pkgs.modernchic

read -d '' -r id name < <(curl -sL 'https://drive.google.com/drive/folders/1OZYZ09n1XKIcStIW9LboYlVR659vtxg6' \
  | sed -nE "s|.*window\\['_DRIVE_ivd'] = '([^']+)'.*|\1|p" \
  | sed 's|\\/|/|g' | sed 's|\\x|\\u00|g' | sed 's|"|\\"|g' | sed 's|.*|"&"|' \
  | jq -r . | jq -r '.[0] | .[] | select(.[3] == "application/x-zip-compressed") | (.[0], .[2])') || true
update-source-version $package \
  "$(echo "$name" | grep -oE '[0-9]+' | sed 's/./&./g; s/.$//')" \
  --url="https://drive.usercontent.google.com/download?export=download&confirm=t&id=$id"
