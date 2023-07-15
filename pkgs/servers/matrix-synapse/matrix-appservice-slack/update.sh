#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../ -i bash -p nix curl jq prefetch-yarn-deps nix-prefetch-github nix-prefetch-git

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates packaging data for matrix-appservice-slack."
  echo "Usage: $0 [git release tag]"
  exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
  version="$(curl "https://api.github.com/repos/matrix-org/matrix-appservice-slack/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

src="https://raw.githubusercontent.com/matrix-org/matrix-appservice-slack/$version"
src_hash=$(nix-prefetch-github matrix-org matrix-appservice-slack --rev ${version} | jq -r .sha256)

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

pushd $tmpdir
curl -O "$src/yarn.lock"
yarn_hash=$(prefetch-yarn-deps yarn.lock)
popd

curl -O "$src/package.json"
cat > pin.json << EOF
{
  "version": "$version",
  "srcHash": "$src_hash",
  "yarnHash": "$yarn_hash"
}
EOF
