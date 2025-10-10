#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
NIX_FILE="$(dirname "$0")/default.nix"
PNAME="droid"
BASE_URL="https://downloads.factory.ai/factory-cli/releases"

# Map Nix platforms to upstream URL paths
declare -A PLATFORM_MAP=(
    ["x86_64-linux"]="linux/x64"
    ["aarch64-linux"]="linux/arm64"
    ["x86_64-darwin"]="darwin/x64"
    ["aarch64-darwin"]="darwin/arm64"
)

# --- Functions ---

# Function to get the current version from the Nix file
get_current_version() {
    grep 'version = ' "$NIX_FILE" | head -n 1 | awk -F'"' '{print $2}'
}

# Function to fetch and convert the hash for a given platform
fetch_and_convert_hash() {
    local nix_platform="$1"
    local upstream_path="$2"
    local new_version="$3"

    local sha_url="$BASE_URL/$new_version/$upstream_path/$PNAME.sha256"
    
    echo "Fetching SHA256 for $nix_platform from $sha_url..." >&2

    # Fetch the hex SHA256 hash
    local hex_sha
    hex_sha=$(curl -fsSL "$sha_url" | tr -d '[:space:]')

    if [[ -z "$hex_sha" ]]; then
        echo "Error: Failed to fetch SHA256 from $sha_url. Check if the version and platform exist." >&2
        exit 1
    fi

    # Convert hex SHA256 to Nix base32 hash
    local nix_sha
    nix_sha=$(nix-hash --type sha256 --to-base32 "$hex_sha")

    echo "$nix_sha"
}

# --- Main Logic ---

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <new-version>"
    echo "Example: $0 0.20.0"
    exit 1
fi

NEW_VERSION="$1"
CURRENT_VERSION=$(get_current_version)

if [[ "$NEW_VERSION" == "$CURRENT_VERSION" ]]; then
    echo "Version is already $NEW_VERSION. Exiting."
    exit 0
fi

echo "Updating $PNAME from $CURRENT_VERSION to $NEW_VERSION..."

# 1. Calculate and store new hashes
declare -A NEW_HASHES
for nix_platform in "${!PLATFORM_MAP[@]}"; do
    NEW_HASHES["$nix_platform"]=$(fetch_and_convert_hash "$nix_platform" "${PLATFORM_MAP[$nix_platform]}" "$NEW_VERSION")
done

# 2. Update the version in default.nix
echo "Updating version in $NIX_FILE..."
sed -i "s/version = \"$CURRENT_VERSION\"/version = \"$NEW_VERSION\"/" "$NIX_FILE"

# 3. Update the hashes in default.nix
echo "Updating hashes in $NIX_FILE..."
for nix_platform in "${!PLATFORM_MAP[@]}"; do
    new_hash="${NEW_HASHES[$nix_platform]}"
    
    # Get the old hash for the current platform from the file
    OLD_HASH=$(grep -A 10 "$nix_platform" "$NIX_FILE" | grep 'sha256 = ' | head -n 1 | awk -F'"' '{print $2}')
    
    if [[ -z "$OLD_HASH" ]]; then
        echo "Warning: Could not find old hash for $nix_platform. Skipping hash update for this platform." >&2
        continue
    fi
    
    # Perform the replacement
    # We use a different delimiter (#) for sed to avoid issues with slashes in the hash string.
    # The pattern to replace is the entire line containing the old hash.
    # Note: The sed command is complex due to the multi-line context. A simpler approach is to replace the hash directly.
    sed -i "s|sha256 = \"$OLD_HASH\"|sha256 = \"$new_hash\"|" "$NIX_FILE"
    echo "  $nix_platform: $new_hash"
done

echo "Update complete. Please verify the changes in $NIX_FILE."