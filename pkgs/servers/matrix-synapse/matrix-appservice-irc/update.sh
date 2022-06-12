#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix curl jq nix nix-prefetch-git

set -euo pipefail
# cd to the folder containing this script
cd "$(dirname "$0")"

CURRENT_VERSION=$(nix-instantiate ../../../../. --eval --strict -A matrix-appservice-irc.version | tr -d '"')
TARGET_VERSION="$(curl https://api.github.com/repos/matrix-org/matrix-appservice-irc/releases/latest | jq --exit-status -r ".tag_name")"

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
    echo "matrix-appservice-irc is up-to-date: ${CURRENT_VERSION}"
    exit 0
fi

echo "matrix-appservice-irc: $CURRENT_VERSION -> $TARGET_VERSION"

rm -f package.json package-lock.json
wget https://github.com/matrix-org/matrix-appservice-irc/raw/$TARGET_VERSION/package.json
wget -O package-lock-temp.json https://github.com/matrix-org/matrix-appservice-irc/raw/$TARGET_VERSION/package-lock.json

./generate-dependencies.sh

rm ./package-lock-temp.json

nix-prefetch-git --rev "$TARGET_VERSION" --url "https://github.com/matrix-org/matrix-appservice-irc" > ./src.json
