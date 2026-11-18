#!/usr/bin/env nix-shell
#!nix-shell -i bash -p ripgrep common-updater-scripts

set -xeu -o pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"
cd "$PACKAGE_DIR/.."
while ! test -f default.nix; do cd .. ; done
NIXPKGS_DIR="$PWD"

latest_version="$(
  list-git-tags --url=https://github.com/linux-apfs/linux-apfs-rw \
  | sort --version-sort \
  | tail -n1
)"

latest_version_no_v_prefix="${latest_version#"v"}"

cd "$NIXPKGS_DIR"
update-source-version linuxPackages.apfs "$latest_version_no_v_prefix" \
  --version-key=tag
