#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/vault-bin.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find vault-bin in $ROOT"
  exit 1
fi

function calc_hash () {
    local version=$1
    local arch=$2
    url="https://releases.hashicorp.com/vault/${version}/vault_${version}_${arch}.zip"
    zip_hash=$(nix-prefetch-url --unpack $url)
    nix hash to-sri --type sha256 "$zip_hash"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

# https://releases.hashicorp.com/vault/1.9.4/vault_1.9.4_linux_arm64.zip
VAULT_VER=$(curl -Ls -w "%{url_effective}" -o /dev/null https://github.com/hashicorp/vault/releases/latest | awk -F'/' '{print $NF}' | sed 's/v//')

VAULT_LINUX_X86_SHA256=$(calc_hash "$VAULT_VER" "linux_386")
VAULT_LINUX_X64_SHA256=$(calc_hash "$VAULT_VER" "linux_amd64")
VAULT_DARWIN_X64_SHA256=$(calc_hash "$VAULT_VER" "darwin_amd64")
VAULT_LINUX_AARCH64_SHA256=$(calc_hash "$VAULT_VER" "linux_arm64")
VAULT_DARWIN_AARCH64_SHA256=$(calc_hash "$VAULT_VER" "darwin_arm64")

sed -i "s/version = \".*\"/version = \"$VAULT_VER\"/" "$NIX_DRV"

replace_sha "i686-linux" "$VAULT_LINUX_X86_SHA256"
replace_sha "x86_64-linux" "$VAULT_LINUX_X64_SHA256"
replace_sha "x86_64-darwin" "$VAULT_DARWIN_X64_SHA256"
replace_sha "aarch64-linux" "$VAULT_LINUX_AARCH64_SHA256"
replace_sha "aarch64-darwin" "$VAULT_DARWIN_AARCH64_SHA256"
