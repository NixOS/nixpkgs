#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl yarn yarn2nix-moretea.yarn2nix nix-prefetch-git jq git

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
dirname="$(dirname "$0")"

latest_release=$(curl --silent https://api.github.com/repos/navidrome/navidrome/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release")
echo "got version $version"
echo \""${version#v}"\" > "$dirname/version.nix"

printf '%s\n' $(nix-prefetch-git --quiet --rev ${version} https://github.com/navidrome/navidrome | jq .sha256) > $dirname/source-sha.nix
echo "zeroing vendorSha256 in $dirname/vendor-sha.nix"
printf '"%s"\n' "0000000000000000000000000000000000000000000000000000" > $dirname/vendor-sha.nix

NAVIDROME_WEB_SRC="https://raw.githubusercontent.com/navidrome/navidrome/$version"

echo "downloading package.json"
curl --silent "$NAVIDROME_WEB_SRC/ui/package.json" -o $dirname/package.json
echo "downloaded package.json"

echo "generating yarn.lock"
yarn install --mode update-lockfile
echo "ran yarn install"

echo "running yarn2nix"
yarn2nix --lockfile=$dirname/yarn.lock > $dirname/yarndeps.nix
echo "ran yarn2nix"

echo "cleaning up"
rm -rf node_modules/ package.json

echo "running nix-build for ui"
nix-build -A navidrome.ui "$nixpkgs"

set +o pipefail
echo "running nix-build for navidrome itself in order to get vendorSha256"
vendorSha256=$(nix-build --no-out-link -A navidrome "$nixpkgs" 2>&1 | grep "got:" | cut -d':' -f3)
echo "got vendorSha256 of: $vendorSha256"
printf '"%s"\n' "$vendorSha256" > $dirname/vendor-sha.nix

echo "running nix-build -A navidrome which should build navidrome normally"
nix-build -A navidrome "$nixpkgs"
