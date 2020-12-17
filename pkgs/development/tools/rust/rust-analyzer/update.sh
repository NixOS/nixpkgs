#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch
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
sed -e "s#rev = \".*\"#rev = \"$rev\"#" \
    -e "s#sha256 = \".*\"#sha256 = \"$sha256\"#" \
    -e "s#cargoSha256 = \".*\"#cargoSha256 = \"\"#" \
    --in-place ./default.nix
node_src="$(nix-build "$nixpkgs" -A rust-analyzer.src --no-out-link)/editors/code"

# Check vscode compatibility
req_vscode_ver="$(jq '.engines.vscode' "$node_src/package.json" --raw-output)"
req_vscode_ver="${req_vscode_ver#^}"
cur_vscode_ver="$(nix-instantiate --eval --strict "$nixpkgs" -A vscode.version | tr -d '"')"
if [[ "$(nix-instantiate --eval --strict -E "(builtins.compareVersions \"$req_vscode_ver\" \"$cur_vscode_ver\")")" -gt 0 ]]; then
    echo "vscode $cur_vscode_ver is incompatible with the extension requiring ^$req_vscode_ver"
    exit 1
fi

echo "Prebuilding for cargoSha256"
cargo_sha256=$(nix-prefetch "{ sha256 }: (import $nixpkgs {}).rust-analyzer-unwrapped.cargoDeps.overrideAttrs (_: { outputHash = sha256; })")
sed "s#cargoSha256 = \".*\"#cargoSha256 = \"$cargo_sha256\"#" \
    --in-place ./default.nix

# Update vscode extension

build_deps="../../../../misc/vscode-extensions/rust-analyzer/build-deps"
# We need devDependencies to build vsix.
jq '{ name, version, dependencies: (.dependencies + .devDependencies) }' "$node_src/package.json" \
    >"$build_deps/package.json.new"

if cmp --quiet "$build_deps"/package.json{.new,}; then
    echo "package.json not changed, skip updating nodePackages"
    rm "$build_deps"/package.json.new
else
    echo "package.json changed, updating nodePackages"
    mv "$build_deps"/package.json{.new,}

    pushd "../../../node-packages"
    ./generate.sh
    popd
fi
