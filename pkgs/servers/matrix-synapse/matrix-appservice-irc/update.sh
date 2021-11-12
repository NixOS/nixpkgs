#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix nodejs-12_x curl jq nix

set -euo pipefail
# cd to the folder containing this script
cd "$(dirname "$0")"

CURRENT_VERSION=$(nix eval --raw '(with import ../../../../. {}; matrix-appservice-irc.version)')
TARGET_VERSION="$(curl https://api.github.com/repos/matrix-org/matrix-appservice-irc/releases/latest | jq -r ".tag_name")"

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
    echo "matrix-appservice-irc is up-to-date: ${CURRENT_VERSION}"
    exit 0
fi

echo "matrix-appservice-irc: $CURRENT_VERSION -> $TARGET_VERSION"

rm -f package.json package-lock.json
wget https://github.com/matrix-org/matrix-appservice-irc/raw/$TARGET_VERSION/package.json
wget -O package-lock-temp.json https://github.com/matrix-org/matrix-appservice-irc/raw/$TARGET_VERSION/package-lock.json
echo "$TARGET_VERSION" > ./REVISION

./generate-dependencies.sh

rm ./package-lock-temp.json

# Apparently this is done by r-ryantm, so only uncomment for manual usage
#git add ./package.json ./node-packages.nix
#git commit -m "matrix-appservice-irc: ${CURRENT_VERSION} -> ${TARGET_VERSION}"
