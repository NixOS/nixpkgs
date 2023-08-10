#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq nix-prefetch-github

set -euo pipefail
cd "$(dirname "$0")"

pname=softether
owner=SoftEtherVPN
repo=SoftEtherVPN_Stable

nixpkgs="$(git rev-parse --show-toplevel)"
current_ver=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).${pname}.version" | tr -d '"')
latest_tag=$(curl -s "https://api.github.com/repos/$owner/$repo/tags" | jq -r ".[].name" | grep -- "-rtm" | head -n1)
latest_ver=$(sed -E 's/v(.+)-.+-rtm/\1/' <<<"$latest_tag")
latest_build=$(sed -E 's/v.+-(.+)-rtm/\1/' <<<"$latest_tag")

if [[ $current_ver == $latest_ver ]]; then
  echo "Already at latest version $latest_ver"
  exit 0
fi
echo "New version: $latest_ver"

newhash=$(nix-prefetch-github --json "$owner" "$repo" --rev "$latest_tag" | jq -r .sha256)

sed -i "s#version = \".*\"#version = \"$latest_ver\"#" default.nix
sed -i "s#build = \".*\"#build = \"$latest_build\"#" default.nix
sed -i "s#sha256 = \".*\"#sha256 = \"$newhash\"#" default.nix
