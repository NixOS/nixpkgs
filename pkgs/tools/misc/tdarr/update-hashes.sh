#!/usr/bin/env bash
set -euo pipefail

# Updates tdarr packages to the latest version
# This script updates both server and node packages since they share the same version

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
COMMON_FILE="$SCRIPT_DIR/common.nix"
SERVER_FILE="$SCRIPT_DIR/server.nix"
NODE_FILE="$SCRIPT_DIR/node.nix"

# Fetch the latest version from the versions.json endpoint
echo "Fetching latest version..." >&2
LATEST_VERSION=$(curl -s https://storage.tdarr.io/versions.json | jq -r 'keys_unsorted | .[0]')

if [[ -z "$LATEST_VERSION" ]]; then
    echo "Error: Could not fetch latest version from versions.json" >&2
    exit 1
fi

echo "Latest version: $LATEST_VERSION" >&2

# Check current version in common.nix
CURRENT_VERSION=$(grep -oP '(?<=version = ")[^"]+' "$COMMON_FILE" 2>/dev/null)

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo "Tdarr packages are already on the latest version ($LATEST_VERSION)" >&2
    exit 0
fi

echo "Updating from $CURRENT_VERSION to $LATEST_VERSION..." >&2

fetch_and_convert() {
    local url=$1
    nix-prefetch-url --unpack "$url" 2>/dev/null | xargs nix hash convert --hash-algo sha256 --to sri
}

# Fetch all hashes for both server and node
echo "Fetching hashes for server version $LATEST_VERSION..." >&2
server_linux_x64=$(fetch_and_convert "https://storage.tdarr.io/versions/$LATEST_VERSION/linux_x64/Tdarr_Server.zip")
server_linux_arm64=$(fetch_and_convert "https://storage.tdarr.io/versions/$LATEST_VERSION/linux_arm64/Tdarr_Server.zip")
server_darwin_x64=$(fetch_and_convert "https://storage.tdarr.io/versions/$LATEST_VERSION/darwin_x64/Tdarr_Server.zip")
server_darwin_arm64=$(fetch_and_convert "https://storage.tdarr.io/versions/$LATEST_VERSION/darwin_arm64/Tdarr_Server.zip")

echo "Fetching hashes for node version $LATEST_VERSION..." >&2
node_linux_x64=$(fetch_and_convert "https://storage.tdarr.io/versions/$LATEST_VERSION/linux_x64/Tdarr_Node.zip")
node_linux_arm64=$(fetch_and_convert "https://storage.tdarr.io/versions/$LATEST_VERSION/linux_arm64/Tdarr_Node.zip")
node_darwin_x64=$(fetch_and_convert "https://storage.tdarr.io/versions/$LATEST_VERSION/darwin_x64/Tdarr_Node.zip")
node_darwin_arm64=$(fetch_and_convert "https://storage.tdarr.io/versions/$LATEST_VERSION/darwin_arm64/Tdarr_Node.zip")

# Update common.nix version
tmpfile=$(mktemp)
awk -v ver="$LATEST_VERSION" '
/^  version = / {
    print "  version = \"" ver "\";"
    next
}
{ print }
' "$COMMON_FILE" > "$tmpfile"
mv "$tmpfile" "$COMMON_FILE"
echo "Updated version in $COMMON_FILE" >&2

# Update server.nix hashes
tmpfile=$(mktemp)
awk -v lx64="$server_linux_x64" -v la64="$server_linux_arm64" -v dx64="$server_darwin_x64" -v da64="$server_darwin_arm64" '
/^  hashes = {$/ {
    print $0
    getline; print "    linux_x64 = \"" lx64 "\";"
    getline; print "    linux_arm64 = \"" la64 "\";"
    getline; print "    darwin_x64 = \"" dx64 "\";"
    getline; print "    darwin_arm64 = \"" da64 "\";"
    getline; print $0
    next
}
{ print }
' "$SERVER_FILE" > "$tmpfile"
mv "$tmpfile" "$SERVER_FILE"
echo "Updated hashes in $SERVER_FILE" >&2

# Update node.nix hashes
tmpfile=$(mktemp)
awk -v lx64="$node_linux_x64" -v la64="$node_linux_arm64" -v dx64="$node_darwin_x64" -v da64="$node_darwin_arm64" '
/^  hashes = {$/ {
    print $0
    getline; print "    linux_x64 = \"" lx64 "\";"
    getline; print "    linux_arm64 = \"" la64 "\";"
    getline; print "    darwin_x64 = \"" dx64 "\";"
    getline; print "    darwin_arm64 = \"" da64 "\";"
    getline; print $0
    next
}
{ print }
' "$NODE_FILE" > "$tmpfile"
mv "$tmpfile" "$NODE_FILE"
echo "Updated hashes in $NODE_FILE" >&2

echo "Successfully updated tdarr to version $LATEST_VERSION" >&2

cat << EOF
[
  {
    "attrPath": "tdarr-server",
    "oldVersion": "$CURRENT_VERSION",
    "newVersion": "$LATEST_VERSION",
    "files": ["$COMMON_FILE", "$SERVER_FILE"]
  },
  {
    "attrPath": "tdarr-node",
    "oldVersion": "$CURRENT_VERSION",
    "newVersion": "$LATEST_VERSION",
    "files": ["$COMMON_FILE", "$NODE_FILE"]
  }
]
EOF
