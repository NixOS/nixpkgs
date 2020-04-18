#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq

set -eu -o pipefail

core_json="$(curl -s --fail --location https://updates.jenkins.io/stable/update-center.actual.json | jq .core)"
oldVersion=$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion jenkins" | tr -d '"')

version="$(jq -r .version <<<$core_json)"
sha256="$(jq -r .sha256 <<<$core_json)"
hash="$(nix-hash --type sha256 --to-base32 "$sha256")"
url="$(jq -r .url <<<$core_json)"

if [ ! "${oldVersion}" = "${version}" ]; then
  update-source-version jenkins "$version" "$hash" "$url"
  nixpkgs="$(git rev-parse --show-toplevel)"
  default_nix="$nixpkgs/pkgs/development/tools/continuous-integration/jenkins/default.nix"
  git add "${default_nix}"
  git commit -m "jenkins: ${oldVersion} -> ${version}"
else
  echo "jenkins is already up-to-date"
fi
