#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch nodePackages.node2nix
set -euo pipefail
cd "$(dirname "$0")"
owner=rust-analyzer
repo=rust-analyzer
nixpkgs=../../../../..

# Update lsp

rev=$(
    curl -s "https://api.github.com/repos/$owner/$repo/releases" |
    jq 'map(select(.prerelease | not)) | .[0].tag_name' --raw-output
)
old_rev=$(sed -nE 's/.*\brev = "(.*)".*/\1/p' ./default.nix)
if grep -q 'cargoSha256 = ""' ./default.nix; then
    old_rev='broken'
fi
if [[ "$rev" == "$old_rev" ]]; then
    echo "Up to date: $rev"
    exit
fi
echo "$old_rev -> $rev"

sha256=$(nix-prefetch -f "$nixpkgs" rust-analyzer-unwrapped.src --rev "$rev")
# Clear cargoSha256 to avoid inconsistency.
sed -e "s/rev = \".*\"/rev = \"$rev\"/" \
    -e "s/sha256 = \".*\"/sha256 = \"$sha256\"/" \
    -e "s/cargoSha256 = \".*\"/cargoSha256 = \"\"/" \
    --in-place ./default.nix
node_src="$(nix-build "$nixpkgs" -A rust-analyzer.src --no-out-link)/editors/code"

# Check vscode compatibility
req_vscode_ver="$(jq '.engines.vscode' "$node_src/package.json" --raw-output)"
req_vscode_ver="${req_vscode_ver#^}"
cur_vscode_ver="$(nix eval --raw -f "$nixpkgs" vscode.version)"
if [[ "$(nix eval "(builtins.compareVersions \"$req_vscode_ver\" \"$cur_vscode_ver\")")" -gt 0 ]]; then
    echo "vscode $cur_vscode_ver is incompatible with the extension requiring ^$req_vscode_ver"
    exit 1
fi

echo "Prebuilding for cargoSha256"
cargo_sha256=$(nix-prefetch "{ sha256 }: (import $nixpkgs {}).rust-analyzer-unwrapped.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
sed "s/cargoSha256 = \".*\"/cargoSha256 = \"$cargo_sha256\"/" \
    --in-place ./default.nix

# Update vscode extension

echo "Generating node lock"
pushd "$nixpkgs/pkgs/misc/vscode-extensions/rust-analyzer"
ext_version=$(jq '.version' "$node_src/package.json" --raw-output)
ext_publisher=$(jq '.publisher' "$node_src/package.json" --raw-output)
echo "Extension version: $ext_version"
[[ "$ext_publisher" == "matklad" ]]
node2nix \
    --nodejs-12 \
    --development \
    --input "$node_src/package.json" \
    --lock "$node_src/package-lock.json" \
    --output ./node-packages.nix \
    --composition ./node-composition.nix \
    --no-copy-node-env \
    --node-env ../../../development/node-packages/node-env.nix
sed -e 's_^.*src = [./]*/nix/store.*__g' \
    --in-place ./node-packages.nix
sed -e "s/version = \".*\"/version = \"$ext_version\"/" \
    --in-place ./default.nix
popd
