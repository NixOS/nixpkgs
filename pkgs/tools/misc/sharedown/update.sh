#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update yarn yarn2nix-moretea.yarn2nix

set -euo pipefail

nix-update sharedown

dirname="$(realpath "$(dirname "$0")")"
sourceDir="$(nix-build -A sharedown.src --no-out-link)"
tempDir="$(mktemp -d)"

cp -r "$sourceDir"/* "$tempDir"
cd "$tempDir"
PUPPETEER_SKIP_DOWNLOAD=1 yarn install
yarn2nix > "$dirname/yarndeps.nix"
cp -r yarn.lock "$dirname"
