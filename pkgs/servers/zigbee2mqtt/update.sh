#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix nodejs-12_x curl jq nix-update
# shellcheck shell=bash

CURRENT_VERSION=$(nix eval --raw '(with import ../../.. {}; zigbee2mqtt.version)')
TARGET_VERSION=$(curl https://api.github.com/repos/Koenkk/zigbee2mqtt/releases/latest | jq -r ".tag_name")
ZIGBEE2MQTT=https://github.com/Koenkk/zigbee2mqtt/raw/$TARGET_VERSION

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
    echo "zigbee2mqtt is up-to-date: ${CURRENT_VERSION}"
    exit 0
fi

curl -LO $ZIGBEE2MQTT/package.json
curl -LO $ZIGBEE2MQTT/npm-shrinkwrap.json

node2nix --nodejs-12 \
  -l npm-shrinkwrap.json \
  -c node.nix \
  --bypass-cache \
  --no-copy-node-env \
  --node-env ../../development/node-packages/node-env.nix
rm package.json npm-shrinkwrap.json

{
    cd ../../..
    nix-update --version "$TARGET_VERSION" --build zigbee2mqtt
}

git add ./default.nix ./node-packages.nix ./node.nix
git commit -m "zigbee2mqtt: ${CURRENT_VERSION} -> ${TARGET_VERSION}"
