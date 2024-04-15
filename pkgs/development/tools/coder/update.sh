#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eu -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

LATEST_TAG=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} --silent https://api.github.com/repos/coder/coder/releases/latest | jq -r '.tag_name')
LATEST_VERSION=$(echo ${LATEST_TAG} | sed 's/^v//')

# change version number
sed -e "s/version =.*;/version = \"$LATEST_VERSION\";/g" \
    -i ./default.nix

# Define the platforms
declare -A ARCHS=(["x86_64-linux"]="linux_amd64.tar.gz"
                  ["aarch64-linux"]="linux_arm64.tar.gz"
                  ["x86_64-darwin"]="darwin_amd64.zip"
                  ["aarch64-darwin"]="darwin_arm64.zip")

# Update hashes for each architecture
for ARCH in "${!ARCHS[@]}"; do
  URL="https://github.com/coder/coder/releases/download/v${LATEST_VERSION}/coder_${LATEST_VERSION}_${ARCHS[$ARCH]}"
  echo "Fetching hash for $ARCH..."

  # Fetch the new hash using nix-prefetch-url
  NEW_HASH=$(nix-prefetch-url --type sha256 $URL)
  SRI_HASH=$(nix hash to-sri --type sha256 $NEW_HASH)

  # Update the Nix file with the new hash
  sed -i "s|${ARCH} = \"sha256-.*\";|${ARCH} = \"${SRI_HASH}\";|" ./default.nix
done
