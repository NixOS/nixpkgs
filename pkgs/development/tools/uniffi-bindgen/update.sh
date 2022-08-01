#!/usr/bin/env nix-shell
#! nix-shell -p nix cargo rsync nix-update
#! nix-shell -i bash

set -euo pipefail

if [[ -z "${UPDATE_NIX_ATTR_PATH+x}" ]]; then
    echo "Error: run the following command from nixpkgs root:" >&2
    echo "  nix-shell maintainers/scripts/update.nix --argstr package uniffi-bindgen" >&2
    exit 1
fi

targetLockfile="$(dirname "$0")/Cargo.lock"

# Update version and hash
nix-update "$UPDATE_NIX_ATTR_PATH"

# Update lockfile through `cargo update`
src=$(nix-build -A "${UPDATE_NIX_ATTR_PATH}.src" --no-out-link)

tmp=$(mktemp -d)

cleanup() {
  echo "Removing $tmp" >&2
  rm -rf "$tmp"
}

trap cleanup EXIT

rsync -a --chmod=ugo=rwX "$src/" "$tmp"

pushd "$tmp"
cargo update
cp "Cargo.lock" "$targetLockfile"
popd
