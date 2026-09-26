#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. --pure -i bash -p bash nix nix-update git cacert common-updater-scripts
set -euo pipefail

versionPrefix=$1
file=$2
attr=godotPackages_${versionPrefix/./_}

prev_version=$(nix eval --raw -f. "$attr".godot)
nix-update "$attr".godot \
    --version-regex "($versionPrefix\\b.*-stable)" \
    --override-filename "$2" \
    --src-only
[[ $(nix eval --raw -f. "$attr".godot) != "$prev_version" ]] || exit 0

fetch_deps=$(nix build -f. "$attr".godot-mono.fetch-deps --print-out-paths --no-link)
"$fetch_deps" >&2

update-source-version "$attr".godot.export-templates-bin --ignore-same-version --file="$file"
update-source-version "$attr".godot-mono.export-templates-bin --ignore-same-version --file="$file"
