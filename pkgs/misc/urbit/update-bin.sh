#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nix-prefetch

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/default.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find urbit in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/urbit/vere/releases/download/vere-v${VER}/${ARCH}.tgz";
  nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = \"vere\"; version = \"${VER}\";
  src = fetchzip { url = \"$URL\"; };
}
"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

VERE_VER=$(curl https://bootstrap.urbit.org/vere/live/last)

VERE_LINUX_AARCH64_SHA256=$(fetch_arch "$VERE_VER" "linux-aarch64")
VERE_LINUX_X64_SHA256=$(fetch_arch "$VERE_VER" "linux-x86_64")
VERE_DARWIN_AARCH64_SHA256=$(fetch_arch "$VERE_VER" "macos-aarch64")
VERE_DARWIN_X64_SHA256=$(fetch_arch "$VERE_VER" "macos-x86_64")

sed -i "s/version = \".*\"/version = \"$VERE_VER\"/" "$NIX_DRV"

replace_sha "aarch64-linux" "$VERE_LINUX_AARCH64_SHA256"
replace_sha "x86_64-linux" "$VERE_LINUX_X64_SHA256"
replace_sha "aarch64-darwin" "$VERE_DARWIN_AARCH64_SHA256"
replace_sha "x86_64-darwin" "$VERE_DARWIN_X64_SHA256"
