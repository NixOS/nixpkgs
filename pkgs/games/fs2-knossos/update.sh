#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts yarn yarn2nix
set -euo pipefail

# Change directory to nixpkgs root so we can run this manually.
expDir="$(realpath "$(dirname "$0")")"
cd "$expDir/../../.."

# Get current and latest versions.
currentVersion=$(nix-instantiate --eval --expr 'with import ./. {}; fs2-knossos.version' | tr -d '"')
latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
  "https://api.github.com/repos/ngld/old-knossos/releases/latest" | jq '.tag_name | split("v") | .[1]' --raw-output)

# Skip version and yarn update when already on the latest version.
if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "No changes, skipping."
    exit 0
fi

# Update the expression's version.
update-source-version fs2-knossos "$latestVersion"

# Prepare source for yarn update.
srcDir="$(nix-build -A fs2-knossos.src --no-out-link)"
tmpDir="$(mktemp -d)"

cp -r "$srcDir"/* "$tmpDir"
cd "$tmpDir"

# Fetch all the optional dependencies, so we have them available in yarn.lock/yarn.nix.
yarn install

# Add needed dependency files to the expression's directory.
yarn2nix > "$expDir/yarn.nix"
cp -f yarn.lock "$expDir"
cp -f package.json "$expDir"
