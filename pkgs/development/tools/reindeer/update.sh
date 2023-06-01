#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix-prefetch common-updater-scripts mktemp nix coreutils

# First, check that we only update once per day since the version tag is dependent on the date.
NEW_VERSION="unstable-$(date -u +%F)"
CURRENT_VERSION=$(nix-instantiate --eval -E "with import ./. {}; reindeer.version" | tr -d '"')
if [[ "$NEW_VERSION" == "$CURRENT_VERSION" ]]; then
    echo "skipping reindeer update within same day (version: \"$CURRENT_VERSION\")"
    exit 0
fi

# Second, let's check if there's a new commit to main.
NEW_REV=$(curl https://api.github.com/repos/facebookincubator/reindeer/branches/main | jq '.commit.sha')
CURRENT_REV=$(nix-instantiate --eval -E "with import ./. {}; reindeer.src.rev")
if [[ "$NEW_REV" == "$CURRENT_REV" ]]; then
    echo "reindeer is up-to-date (rev: $CURRENT_REV)"
    exit 0
fi
echo "updating reindeer (new: $NEW_REV) (old: $CURRENT_REV)"

# Generate the new lockfile in a temporary directory.
pushd $(mktemp -d)
git clone https://github.com/facebookincubator/reindeer.git --depth=1
pushd reindeer
cargo generate-lockfile
LOCKFILE=$(realpath ./Cargo.lock)
popd
popd
cp $LOCKFILE pkgs/development/tools/reindeer/

# Get the new sha256 value.
TRIMMED_REV=$(echo $NEW_REV | tr -d '"')
HASH_RAW=$(nix-prefetch-url https://github.com/facebookincubator/reindeer/archive/${TRIMMED_REV}.tar.gz --unpack --type sha256)
HASH_SRI=$(nix hash to-sri --type sha256 ${HASH_RAW})

# Update the file accordingly.
update-source-version reindeer "$NEW_VERSION" ${HASH_SRI} --rev=${TRIMMED_REV}
