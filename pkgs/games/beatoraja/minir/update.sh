#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

package=beatoraja.pkgs.minir

indexjs=$(curl -sL "https://www.gaftalk.com$(curl -sL 'https://www.gaftalk.com/minir' | grep -oE '/minir/assets/index-.+\.js' | head -n 1)")
fileId=$(echo "$indexjs" | sed -nE 's|.*https://drive.google.com/open\?id=([^"]+).*|\1|p')
version=$(echo "$indexjs" | sed -nE 's|.*minir-([0-9]+).*|\1|p' | sort | tail -n 1)
update-source-version $package $version --url="https://drive.google.com/uc?export=download&confirm=t&id=$fileId"
