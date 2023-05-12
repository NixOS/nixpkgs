#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix-prefetch common-updater-scripts mktemp nix coreutils

# First, check the "latest" tag (which is re-created often) to see if there's a new commit sha.
# If there is a new commit sha, then we need to update buck2.
NEW_REV=$(curl https://api.github.com/repos/facebook/buck2/tags | jq '.[] | select(.name="latest") | .commit.sha')
CURRENT_REV=$(nix-instantiate --eval -E "with import ./. {}; buck2.src.rev")
if [[ "$NEW_REV" == "$CURRENT_REV" ]]; then
    echo "buck2 is up-to-date (rev: $CURRENT_REV)"
    exit 0
fi
echo "found new rev for buck2 (new: $NEW_REV) (old: $CURRENT_REV)"

# Second, check that we only update once per day since the version tag is dependent on the date.
NEW_VERSION="unstable-$(date +%F)"
CURRENT_VERSION=$(nix-instantiate --eval -E "with import ./. {}; buck2.version" | tr -d '"')
if [[ "$NEW_VERSION" == "$CURRENT_VERSION" ]]; then
    echo "skipping buck2 update within same day (version: \"$CURRENT_VERSION\")"
    exit 0
fi
echo "updating buck2 (new: \"$NEW_VERSION\") (old: \"$CURRENT_VERSION\")"

# Generate the new lockfile in a temporary directory.
pushd $(mktemp -d)
git clone https://github.com/facebook/buck2.git
pushd buck2
cargo generate-lockfile
LOCKFILE=$(realpath ./Cargo.lock)
popd
popd
cp $LOCKFILE pkgs/development/tools/build-managers/buck2/

# Get the new sha256 value.
HASH_RAW=$(nix-prefetch-url https://github.com/facebook/buck2/archive/refs/tags/latest.tar.gz --unpack --type sha256)
HASH_SRI=$(nix hash to-sri --type sha256 ${HASH_RAW})

# Update the file accordingly.
TRIMMED_REV=$(echo $NEW_REV | tr -d '"')
update-source-version buck2 "$NEW_VERSION" ${HASH_SRI} --rev=${TRIMMED_REV}
