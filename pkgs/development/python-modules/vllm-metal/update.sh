#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p cacert cargo common-updater-scripts curl gnused jq nix
set -euo pipefail

SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fetch the latest tag from vllm-metal's GitHub repo
LATEST_TAG=$(
  curl -sSf "https://api.github.com/repos/vllm-project/vllm-metal/tags" \
    | jq -r '.[0].name'
)

# Extract base version (e.g. v0.3.0.dev20260807121336 -> 0.3.0)
BASE_VERSION=$(sed -E 's/^v([0-9]+\.[0-9]+\.[0-9]+)\..*/\1/' <<<"${LATEST_TAG}")

# Extract date (e.g. 20260807 -> 2026-08-07)
DATE_RAW=$(grep -oE '[0-9]{8}' <<<"${LATEST_TAG}")
VERSION_DATE="${DATE_RAW:0:4}-${DATE_RAW:4:2}-${DATE_RAW:6:2}"

NEW_VERSION="${BASE_VERSION}-unstable-${VERSION_DATE}"

# Update version, rev, and source hash
update-source-version \
  python3Packages.vllm-metal \
  "$NEW_VERSION" \
  --rev="$LATEST_TAG"

# Regenerate Cargo.lock: build the source, generate lockfile, copy it back
SRC_DIR=$(nix build --no-link --print-out-paths .#python3Packages.vllm-metal.src)

TMPDIR=$(mktemp -d)
cp -r "$SRC_DIR"/* "$TMPDIR/"
chmod -R u+w "$TMPDIR"
(cd "$TMPDIR" && cargo generate-lockfile)
cp "$TMPDIR/Cargo.lock" "$SCRIPT_DIR/Cargo.lock"
echo "Updated Cargo.lock"
rm -rf "$TMPDIR"
