#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix jq gnutar gzip curl moreutils common-updater-scripts
set -euo pipefail

cd "$(dirname $(readlink -f $0))"

NEW_VERSION="$(curl -s https://api.github.com/repos/gchq/CyberChef/releases | jq -r .[0].tag_name)"
# Strip the 'v' from the version (v9.37.3 -> 9.37.3)
NEW_VERSION="${NEW_VERSION:1}"

curl -L "https://github.com/gchq/CyberChef/archive/refs/tags/v$NEW_VERSION.tar.gz" | \
  tar --strip-components=1 -zxf - "CyberChef-$NEW_VERSION/package.json" "CyberChef-$NEW_VERSION/package-lock.json"

# Further discussion of this in the default.nix buildPhase
jq 'del(.scripts.postinstall)' package.json | sponge package.json

node2nix \
  --development \
  --pkg-name nodejs-17_x \
  --input ./package.json \
  --supplement-input ./supplement.json \
  --composition /dev/null \
  --lock ./package-lock.json

rm -v package-lock.json

# nixpkgs root
cd ../../../../

update-source-version cyberchef "$NEW_VERSION"
