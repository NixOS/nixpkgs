#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gawk gnused pup jq

set -euo pipefail

DIRNAME=$(dirname "$0")
readonly DIRNAME
readonly NIXPKGS_ROOT="../../../.."
readonly NIX_FLAGS=(--extra-experimental-features 'nix-command flakes')

# awk is used for parsing the RARLAB website to get the newest version
readonly AWK_FIELD_SEPARATOR='[-.]'
# shellcheck disable=SC2016
readonly AWK_COMMAND='
# We will get the following output from pup:
# /rar/rarlinux-x64-700b3.tar.gz
# /rar/rarmacos-x64-700b3.tar.gz
# /rar/rarlinux-x64-624.tar.gz
# /rar/rarbsd-x64-624.tar.gz
# /rar/rarmacos-x64-624.tar.gz

# Ignore anything that is flagged as beta (e.g.: `/rar/rarlinux-x64-700b3.tar.gz`)
!/[0-9]+b[0-9]*.tar.gz$/ {
    # /rar/rarlinux-x64-624.tar.gz -> 624
    val = $3
    # Only get the value if it is bigger than the current one
    if (val > max) max = val
}
END {
    # 624 -> 6.24
    printf "%.2f\n", max/100
}
'

updateHash() {
    local -r version="${1//./}"
    local -r arch="$2"
    local -r os="$3"
    local -r nix_arch="$4"

    url="https://www.rarlab.com/rar/rar$os-$arch-$version.tar.gz"
    hash=$(nix store prefetch-file --json "$url" | jq -r .hash)
    currentHash=$(cd "$DIRNAME" && nix "${NIX_FLAGS[@]}" eval --raw "$NIXPKGS_ROOT#legacyPackages.$nix_arch.rar.src.outputHash")

    sed -i "s|$currentHash|$hash|g" "$DIRNAME/default.nix"
}

updateVersion() {
    local -r version="$1"
    sed -i "s|version = \"[0-9.]*\";|version = \"$version\";|g" "$DIRNAME/default.nix"
}

latestVersion="${1:-}"
if [[ -z "$latestVersion" ]]; then
    latestVersion=$(
        curl --silent --location --fail https://www.rarlab.com/download.htm | \
            pup 'a[href*=".tar.gz"] attr{href}' | \
            awk -F"$AWK_FIELD_SEPARATOR" "$AWK_COMMAND"
    )
fi
readonly latestVersion
echo "Latest version: $latestVersion"

currentVersion=$(cd "$DIRNAME" && nix "${NIX_FLAGS[@]}" eval --raw "$NIXPKGS_ROOT#legacyPackages.x86_64-linux.rar.version")
readonly currentVersion
echo "Current version: $currentVersion"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "rar is up-to-date"
    exit 0
fi

updateHash "$latestVersion" x32 linux i686-linux
updateHash "$latestVersion" x64 linux x86_64-linux
updateHash "$latestVersion" arm macos aarch64-darwin
updateHash "$latestVersion" x64 macos x86_64-darwin

updateVersion "$latestVersion"
