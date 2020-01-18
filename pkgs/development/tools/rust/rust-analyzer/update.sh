#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-github
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
if grep -q '0000000000000000000000000000000000000000000000000000' ./default.nix; then
    old_rev='broken'
fi
if [[ "$rev" == "$old_rev" ]]; then
    echo "Up to date: $rev"
    exit
fi
echo "$old_rev -> $rev"

sha256=$(nix-prefetch-github --prefetch "$owner" "$repo" --rev "$rev" | jq '.sha256' --raw-output)
sed -e "s/rev = \".*\"/rev = \"$rev\"/" \
    -e "s/sha256 = \".*\"/sha256 = \"$sha256\"/" \
    -e "s/cargoSha256 = \".*\"/cargoSha256 = \"0000000000000000000000000000000000000000000000000000\"/" \
    --in-place ./default.nix

echo "Prebuilding nix"
cargo_sha256=$({
    ! nix-build "$nixpkgs" -A rust-analyzer-unwrapped --no-out-link 2>&1
} | tee /dev/stderr | sed -nE 's/\s*got:\s*sha256:(\w+)/\1/p' | head -n1)
echo "cargoSha256: $cargo_sha256"
[[ "$cargo_sha256" ]]
sed "s/cargoSha256 = \".*\"/cargoSha256 = \"$cargo_sha256\"/" \
    --in-place ./default.nix

