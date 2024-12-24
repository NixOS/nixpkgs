#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update jq elixir npm-lockfile-fix nixfmt-rfc-style

set -euxo pipefail

nix-update plausible

version="$(nix-instantiate -A plausible.version --eval --json | jq -r)"
source_url="$(nix-instantiate -A plausible.src.url --eval --json | jq -r)"

nix-update --url "$source_url" --version "$version" plausible.tracker
nix-update --url "$source_url" --version "$version" plausible.assets


