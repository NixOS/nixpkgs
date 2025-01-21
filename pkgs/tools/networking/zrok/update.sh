#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/default.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find default.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/openziti/zrok/releases/download/v${VER}/zrok_${VER}_${ARCH}.tar.gz"
  nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = \"zrok\"; version = \"${VER}\";
  src = fetchzip { url = \"$URL\"; stripRoot = false; };
}
"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

ZROK_VER=$(curl -Ls -w "%{url_effective}" -o /dev/null https://github.com/openziti/zrok/releases/latest | awk -F'/' '{print $NF}' | sed 's/v//')

ZROK_LINUX_X64_SHA256=$(fetch_arch "$ZROK_VER" "linux_amd64")
ZROK_LINUX_AARCH64_SHA256=$(fetch_arch "$ZROK_VER" "linux_arm64")
ZROK_LINUX_ARMV7L_SHA256=$(fetch_arch "$ZROK_VER" "linux_armv7")

sed -i "s/version = \".*\"/version = \"$ZROK_VER\"/" "$NIX_DRV"

replace_sha "x86_64-linux" "$ZROK_LINUX_X64_SHA256"
replace_sha "aarch64-linux" "$ZROK_LINUX_AARCH64_SHA256"
replace_sha "armv7l-linux" "$ZROK_LINUX_ARMV7L_SHA256"
