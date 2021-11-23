#!/usr/bin/env nix-shell
#!nix-shell -i bash -p wget yarn2nix-moretea.yarn2nix nix-prefetch-git jq
# shellcheck shell=bash

set -euo pipefail

dirname="$(dirname "$0")"

latest_release=$(curl --silent https://api.github.com/repos/gotify/server/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release")
echo got version $version
echo \""${version#v}"\" > "$dirname/version.nix"
printf '%s\n' $(nix-prefetch-git --quiet --rev ${version} https://github.com/gotify/server | jq .sha256) > $dirname/source-sha.nix
tput setaf 1
echo zeroing vendorSha256 in $dirname/vendor-sha.nix
tput sgr0
printf '"%s"\n' "0000000000000000000000000000000000000000000000000000" > $dirname/vendor-sha.nix

GOTIFY_WEB_SRC="https://raw.githubusercontent.com/gotify/server/$version"

curl --silent "$GOTIFY_WEB_SRC/ui/package.json" -o $dirname/package.json
echo downloaded package.json
curl --silent "$GOTIFY_WEB_SRC/ui/yarn.lock" -o $dirname/yarn.lock
echo downloaded yarndeps.nix
echo running yarn2nix
yarn2nix --lockfile=$dirname/yarn.lock > $dirname/yarndeps.nix
rm $dirname/yarn.lock
echo removed yarn.lock

echo running nix-build for ui
nix-build -A gotify-server.ui
echo running nix-build for gotify itself in order to get vendorSha256
set +e
vendorSha256="$(nix-build -A gotify-server 2>&1 | grep "got:" | cut -d':' -f3)"
set -e
printf '"%s"\n' "$vendorSha256" > $dirname/vendor-sha.nix
tput setaf 2
echo got vendorSha256 of: $vendorSha256
tput sgr0
echo running nix-build -A gotify-server which should build gotify-server normally
nix-build -A gotify-server
