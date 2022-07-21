#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../ -i bash -p nix wget prefetch-yarn-deps nix-prefetch-github jq

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for the element packages."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
  version="$(wget -O- "https://api.github.com/repos/hedgedoc/hedgedoc/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

src="https://raw.githubusercontent.com/hedgedoc/hedgedoc/$version"
wget "$src/package.json" -O package.json
wget "$src/yarn.lock" -O yarn.lock
sed 's;midi "https://github\.com/paulrosen/MIDI\.js\.git;midi "git+https://github.com/paulrosen/MIDI.js.git;g' -i yarn.lock

src_hash=$(nix-prefetch-github hedgedoc hedgedoc --rev ${version} | jq -r .sha256)
yarn_hash=$(prefetch-yarn-deps yarn.lock)

cat > pin.json << EOF
{
  "version": "$version",
  "srcHash": "$src_hash",
  "yarnHash": "$yarn_hash"
}
EOF
