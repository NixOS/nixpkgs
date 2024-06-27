#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -exu -o pipefail

mainManifest=$(curl -s 'https://launchermeta.mojang.com/v1/products/launcher/6f083b80d5e6fabbc4236f81d0d8f8a350c665a9/linux.json')
version=$(echo "$mainManifest" | jq -r '."launcher-core-ado"[0].version.name')
launcherManifest=$(echo "$mainManifest" | jq -r '."launcher-bootstrap-ado"[0].manifest.url' | xargs curl -s )
newSha=$(echo "$launcherManifest" | jq -r '.files."minecraft-launcher".downloads.raw.sha1')
newURL=$(echo "$launcherManifest" | jq -r '.files."minecraft-launcher".downloads.raw.url')

update-source-version minecraft-autoupdate.bootstrap "${version}" "${newSha}" "${newURL}"
