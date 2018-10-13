#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq

set -eu -o pipefail

core_json="$(curl --fail --location https://updates.jenkins.io/stable/update-center.actual.json | jq .core)"

version="$(jq -r .version <<<$core_json)"
sha256="$(jq -r .sha256 <<<$core_json)"
hash="$(nix-hash --type sha256 --to-base32 "$sha256")"
url="$(jq -r .url <<<$core_json)"

update-source-version jenkins "$version" "$hash" "$url"
