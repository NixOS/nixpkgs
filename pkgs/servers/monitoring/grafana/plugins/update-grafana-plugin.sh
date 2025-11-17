#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix curl jq common-updater-scripts

set -eu -o pipefail

cd "${0%/*}"/../../../../../


readonly plugin_name="$1"
readonly api_response="$(curl --silent "https://grafana.com/api/plugins/${plugin_name}")"
readonly latest_version="$(echo "$api_response" | jq -r .version)"

update() {
    local system="${2:+--system=$2}"
    local pkg="$(echo "$api_response" | jq -e .packages.\""$1"\")"
    if echo "$pkg" | jq -er .sha256 > /dev/null; then
        local hash="$(echo "$pkg" | jq -er .sha256)"
    else
        # Some packages only have an md5 hash. Download the file for hash computation.
        local urlPath="$(echo "$pkg" | jq -er .downloadUrl)"
        local hash="$(nix-prefetch-url --type sha256 --name "$plugin_name" "https://grafana.com$urlPath")"
    fi
    hash="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$hash")"
    # Set version number to a random number first to force update to happen.
    #
    # `update-source-version` will exit early if it considers the version number to be the same.
    # However we have already downloaded the file and computed the hash, so it makes sense to set
    # the newly computed information unconditionally.
    #
    # As an example of a workflow that was made more complicated than strictly necessary is my own
    # attempts to improve this script where I spent multiple hours investigating why the update
    # script would refuse to update a hash that I intentionally malformed (in hopes to test the
    # operation of this script.)
    update-source-version $system "grafanaPlugins.${plugin_name}" $RANDOM "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    update-source-version $system "grafanaPlugins.${plugin_name}" "$latest_version" "$hash"
}

if echo "$api_response" | jq -e .packages.any > /dev/null; then
    # the package contains an "any" package, so there should be only one zipHash.
    update "any"
else
    update "linux-amd64" "x86_64-linux"
    update "linux-arm64" "aarch64-linux"
    update "darwin-amd64" "x86_64-darwin"
    update "darwin-arm64" "aarch64-darwin"
fi
