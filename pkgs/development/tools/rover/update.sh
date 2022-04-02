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
rover_sri_hash=$(nix hash to-sri --type sha256 "$rover_hash")

# Identify librusty version and hash
librusty_version=$(
    sed --quiet '/^name = "v8"$/{n;p}' "${repo}/Cargo.lock" \
        | grep --only-matching --perl-regexp '^version = "\K[^"]+'
)
librusty_arch=x86_64-unknown-linux-gnu
librusty_url="https://github.com/denoland/rusty_v8/releases/download/v${librusty_version}/librusty_v8_release_${librusty_arch}.a"
echo "Fetching librusty"
librusty_hash=$(nix-prefetch-url "$librusty_url" --type sha256)
librusty_sri_hash=$(nix hash to-sri --type sha256 "$librusty_hash")

# Update rover version.
sed --in-place \
    "s|version = \"[0-9.]*\"|version = \"$rover_version\"|" \
    "$dirname/default.nix"

# Update rover hash.
sed --in-place \
    "s|sha256 = \"[a-zA-Z0-9\/+-=]*\"|sha256 = \"$rover_sri_hash\"|" \
    "$dirname/default.nix"

# Clear cargoSha256.
sed --in-place \
    "s|cargoSha256 = \".*\"|cargoSha256 = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\"|" \
    "$dirname/default.nix"

# Update cargoSha256
echo "Computing cargoSha256"
cargoSha256=$(
    nix-prefetch "{ sha256 }: (import $nixpkgs {}).rover.cargoDeps.overrideAttrs (_: { outputHash = sha256; })"
)
sed --in-place \
    "s|cargoSha256 = \".*\"|cargoSha256 = \"$cargoSha256\"|" \
    "$dirname/default.nix"

# Update librusty version
sed --in-place \
    "s|version = \"[0-9.]*\"|version = \"$librusty_version\"|" \
    "$dirname/librusty_v8.nix"

# Update librusty hash
sed --in-place \
    "s|x86_64-linux = \"[^\"]*\"|x86_64-linux = \"$librusty_sri_hash\"|" \
    "$dirname/librusty_v8.nix"

# Update apollo api schema info
response="$(mktemp)"
schemaUrl=https://graphql.api.apollographql.com/api/schema

mkdir -p "$dirname"/schema

# Fetch schema info
echo "Fetching Apollo GraphQL schema"
# include response headers, and append terminating newline to response body
curl --include --write-out "\n" "$schemaUrl" > "$response"

# Parse response headers and write the etag to schema/etag.id
grep \
    --max-count=1 \
    --only-matching \
    --perl-regexp \
    '^etag: \K\S*' \
    "$response" \
    > "$dirname"/schema/etag.id

# Discard headers and blank line (terminated by carriage return), and write the
# response body to schema/schema.graphql
sed '1,/^\r/d' "$response" > "$dirname"/schema/schema.graphql
