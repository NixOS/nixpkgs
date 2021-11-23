#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch
# shellcheck shell=bash

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/default.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find default.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://releases.hashicorp.com/boundary/${VER}/boundary_${VER}_${ARCH}.zip"
  nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = \"boundary\"; version = \"${VER}\";
  src = fetchzip { url = \"$URL\"; };
}
"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

# https://releases.hashicorp.com/boundary/0.1.4/boundary_0.1.4_linux_amd64.zip
BOUNDARY_VER=$(curl -Ls -w "%{url_effective}" -o /dev/null https://github.com/hashicorp/boundary/releases/latest | awk -F'/' '{print $NF}' | sed 's/v//')

BOUNDARY_LINUX_X64_SHA256=$(fetch_arch "$BOUNDARY_VER" "linux_amd64")
BOUNDARY_DARWIN_X64_SHA256=$(fetch_arch "$BOUNDARY_VER" "darwin_amd64")
BOUNDARY_LINUX_AARCH64_SHA256=$(fetch_arch "$BOUNDARY_VER" "linux_arm64")

sed -i "s/version = \".*\"/version = \"$BOUNDARY_VER\"/" "$NIX_DRV"

replace_sha "x86_64-linux" "$BOUNDARY_LINUX_X64_SHA256"
replace_sha "x86_64-darwin" "$BOUNDARY_DARWIN_X64_SHA256"
replace_sha "aarch64-linux" "$BOUNDARY_LINUX_AARCH64_SHA256"
