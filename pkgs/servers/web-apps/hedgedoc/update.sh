#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../ -i bash -p nix wget prefetch-yarn-deps nix-prefetch-github jq
set -euo pipefail
cd "$(dirname "$0")"

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the element packages."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

if [ -z "$version" ]; then
  version="$(wget -O- "https://api.github.com/repos/hedgedoc/hedgedoc/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

src="https://raw.githubusercontent.com/hedgedoc/hedgedoc/$version"
wget "$src/package.json" -O package.json

src_hash=$(nix-prefetch-github hedgedoc hedgedoc --rev "${version}" | jq -r .sha256)
yarn_hash=$(prefetch-yarn-deps yarn.lock)

sed -i "s/version = \".*\"/version = \"$version\"/" default.nix
sed -i "s/hash = \".*\"/hash = \"$src_hash\"/" default.nix
sed -i "s/sha256 = \".*\"/sha256 = \"$yarn_hash\"/" default.nix
