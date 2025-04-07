#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. --pure -i bash -p bash nix nix-update git cacert common-updater-scripts --keep UPDATE_NIX_ATTR_PATH --keep UPDATE_NIX_OLD_VERSION
set -euo pipefail

versionPrefix=$1
file=$2
attr=$UPDATE_NIX_ATTR_PATH

prev_version=$UPDATE_NIX_OLD_VERSION
nix-update "$attr" \
    --version-regex "($versionPrefix\\b.*-stable)" \
    --override-filename "$2" \
    --src-only
[[ $(nix eval --raw -f. "$attr".version) != "$prev_version" ]] || exit 0

"$(nix build --impure --expr "((import ./. {}).$attr.override { withMono = true; }).fetch-deps" --print-out-paths --no-link)"

update-source-version "$attr" --ignore-same-version --source-key=export-templates-bin --file="$file"
