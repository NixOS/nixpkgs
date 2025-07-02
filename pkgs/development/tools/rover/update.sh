#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq nix-prefetch

set -eu -o pipefail

dirname=$(realpath "$(dirname "$0")")
nixpkgs=$(realpath "${dirname}/../../../..")

old_rover_version=$(nix eval --raw -f "$nixpkgs" rover.version)
rover_url=https://api.github.com/repos/apollographql/rover/releases/latest
rover_tag=$(curl "$rover_url" | jq --raw-output ".tag_name")
rover_version="$(expr "$rover_tag" : 'v\(.*\)')"

if [[ "$old_rover_version" == "$rover_version" ]]; then
    echo "rover is up-to-date: ${old_rover_version}"
    exit 0
fi

echo "Fetching rover"
rover_tar_url="https://github.com/apollographql/rover/archive/refs/tags/${rover_tag}.tar.gz"
{
    read rover_hash
    read repo
} < <(nix-prefetch-url "$rover_tar_url" --unpack --type sha256 --print-path)

# Convert hash to SRI representation
rover_sri_hash=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$rover_hash")

# Update rover version.
sed --in-place \
    "s|version = \"[0-9.]*\"|version = \"$rover_version\"|" \
    "$dirname/default.nix"

# Update rover hash.
sed --in-place \
    "s|sha256 = \"[a-zA-Z0-9\/+-=]*\"|sha256 = \"$rover_sri_hash\"|" \
    "$dirname/default.nix"

# Clear cargoHash.
sed --in-place \
    "s|cargoHash = \".*\"|cargoHash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\"|" \
    "$dirname/default.nix"

# Update cargoHash
echo "Computing cargoHash"
cargoHash=$(
    nix-prefetch "{ hash }: (import $nixpkgs {}).rover.cargoDeps.overrideAttrs (_: { outputHash = hash; })"
)
sed --in-place \
    "s|cargoHash = \".*\"|cargoHash = \"$cargoHash\"|" \
    "$dirname/default.nix"
