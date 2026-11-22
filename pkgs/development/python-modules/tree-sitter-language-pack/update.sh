#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash curl jq gnused coreutils nix nix-update

set -euo pipefail

PACKAGE_DIR="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P)"
NIXPKGS_ROOT="$(cd -- "$PACKAGE_DIR/../../../.." >/dev/null 2>&1 && pwd -P)"
PACKAGE_FILE="$PACKAGE_DIR/default.nix"
ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-python3Packages.tree-sitter-language-pack}"

latest_version() {
  curl -sL ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} \
    "https://api.github.com/repos/kreuzberg-dev/tree-sitter-language-pack/releases/latest" \
    | jq -r '.tag_name | sub("^v"; "")'
}

replace_value() {
  local pattern="$1"
  local replacement="$2"
  sed -i "s|$pattern|$replacement|g" "$PACKAGE_FILE"
}

replace_perl() {
  local pattern="$1"
  local replacement="$2"
  perl -0pi -e "s|$pattern|$replacement|s" "$PACKAGE_FILE"
}

prefetch_sri() {
  local url="$1"
  local hash
  hash="$(nix-prefetch-url --type sha256 "$url")"
  nix hash convert --hash-algo sha256 --to sri "$hash"
}

version="${1:-$(latest_version)}"

if [[ "$version" == "${UPDATE_NIX_OLD_VERSION:-}" ]]; then
  echo "$ATTR_PATH is already at $version"
  exit 0
fi

nix-update "$ATTR_PATH" --version "$version"

release_url="https://github.com/kreuzberg-dev/tree-sitter-language-pack/releases/download/v$version"

manifest_hash="$(prefetch_sri "$release_url/parsers.json")"
aarch64_darwin_hash="$(prefetch_sri "$release_url/parsers-macos-arm64.tar.zst")"
aarch64_linux_hash="$(prefetch_sri "$release_url/parsers-linux-aarch64.tar.zst")"
x86_64_linux_hash="$(prefetch_sri "$release_url/parsers-linux-x86_64.tar.zst")"

replace_perl '(parserManifest = fetchurl \{\n    url = "\$\{parserReleaseUrl finalAttrs\.version\}/parsers\.json";\n    hash = ")[^"]*(";)' "\${1}$manifest_hash\${2}"
replace_perl '(aarch64-darwin = \{\n      suffix = "macos-arm64";\n      hash = ")[^"]*(";)' "\${1}$aarch64_darwin_hash\${2}"
replace_perl '(aarch64-linux = \{\n      suffix = "linux-aarch64";\n      hash = ")[^"]*(";)' "\${1}$aarch64_linux_hash\${2}"
replace_perl '(x86_64-linux = \{\n      suffix = "linux-x86_64";\n      hash = ")[^"]*(";)' "\${1}$x86_64_linux_hash\${2}"

old_cargo_hash="$(
  perl -0ne 'print "$1\n" if /cargoDeps = rustPlatform\.fetchCargoVendor \{\n(?:.*\n)*?    hash = "([^"]+)";/s' "$PACKAGE_FILE"
)"
fake_hash='sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
replace_value "$old_cargo_hash" "$fake_hash"

set +e
build_output="$(
  cd "$NIXPKGS_ROOT" &&
    nix build ".#$ATTR_PATH" 2>&1 >/dev/null
)"
build_status=$?
set -e

if [[ $build_status -eq 0 ]]; then
  echo "expected cargo hash mismatch build to fail, but it succeeded" >&2
  exit 1
fi

new_cargo_hash="$(printf '%s\n' "$build_output" | sed -n 's/.*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*/\1/p' | head -n1)"

if [[ -z "$new_cargo_hash" ]]; then
  printf '%s\n' "$build_output" >&2
  echo "failed to extract cargo hash from build output" >&2
  exit 1
fi

replace_value "$fake_hash" "$new_cargo_hash"

echo "updated $ATTR_PATH to $version"
