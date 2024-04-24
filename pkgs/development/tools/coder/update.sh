#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eu -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# Fetch the latest stable version
LATEST_STABLE_TAG=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} --silent https://api.github.com/repos/coder/coder/releases/latest | jq -r '.tag_name')
LATEST_STABLE_VERSION=$(echo ${LATEST_STABLE_TAG} | sed 's/^v//')

# Fetch the latest mainline version
LATEST_MAINLINE_TAG=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} --silent https://api.github.com/repos/coder/coder/releases | jq -r '.[0].tag_name')
LATEST_MAINLINE_VERSION=$(echo ${LATEST_MAINLINE_TAG} | sed 's/^v//')

# Define the platforms
declare -A ARCHS=(["x86_64-linux"]="linux_amd64.tar.gz"
                  ["aarch64-linux"]="linux_arm64.tar.gz"
                  ["x86_64-darwin"]="darwin_amd64.zip"
                  ["aarch64-darwin"]="darwin_arm64.zip")

update_version_and_hashes() {
    local version=$1
    local channel=$2

    # Update version number, using '#' as delimiter
    sed -i "/${channel} = {/,/};/{
        s#^\(\s*\)version = .*#\1version = \"$version\";#
    }" ./default.nix

    # Update hashes for each architecture
    for ARCH in "${!ARCHS[@]}"; do
        local URL="https://github.com/coder/coder/releases/download/v${version}/coder_${version}_${ARCHS[$ARCH]}"
        echo "Fetching hash for $channel/$ARCH..."

        # Fetch the new hash using nix-prefetch-url
        local NEW_HASH=$(nix-prefetch-url --type sha256 $URL)
        local SRI_HASH=$(nix hash to-sri --type sha256 $NEW_HASH)

        # Update the Nix file with the new hash, using '#' as delimiter and preserving indentation
        sed -i "/${channel} = {/,/};/{
            s#^\(\s*\)${ARCH} = .*#\1${ARCH} = \"${SRI_HASH}\";#
        }" ./default.nix
    done
}

# Update stable channel
update_version_and_hashes $LATEST_STABLE_VERSION "stable"

# Update mainline channel
update_version_and_hashes $LATEST_MAINLINE_VERSION "mainline"
