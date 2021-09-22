#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix-prefetch
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
if [[ $# -ne 1 ]]; then
    echo "Usage: ./update.sh <version>"
    exit 1
fi

echo "
FIXME: This script doesn't update patched lldb. Please manually check branches
of https://github.com/vadimcn/llvm-project and update lldb with correct version of LLVM.
"

nixpkgs=../../../..
nixFile=./default.nix
owner=vadimcn
repo=vscode-lldb
version="$1"

sed -E 's/\bversion = ".*?"/version = "'$version'"/' --in-place "$nixFile"
srcHash=$(nix-prefetch fetchFromGitHub --owner vadimcn --repo vscode-lldb --rev "v$version" --fetchSubmodules)
sed -E 's#\bsha256 = ".*?"#sha256 = "'$srcHash'"#' --in-place "$nixFile"
cargoHash=$(nix-prefetch "{ sha256 }: (import $nixpkgs {}).vscode-extensions.vadimcn.vscode-lldb.adapter.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
sed -E 's#\bcargoSha256 = ".*?"#cargoSha256 = "'$cargoHash'"#' --in-place "$nixFile"

src="$(nix-build $nixpkgs -A vscode-extensions.vadimcn.vscode-lldb.src --no-out-link)"
jq '{ name, version: $version, dependencies: (.dependencies + .devDependencies) }' \
    --arg version "$version" \
    "$src/package.json" \
    > build-deps/package.json

# Regenerate nodePackages.
cd "$nixpkgs/pkgs/development/node-packages"
exec ./generate.sh
