#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../.. -i bash -p nodePackages.node2nix curl jq nix-update common-updater-scripts

set -euo pipefail

CURRENT_VERSION=$(nix eval -f ../../.. --raw zigbee2mqtt.version)
TARGET_VERSION="$(curl https://api.github.com/repos/Koenkk/zigbee2mqtt/releases/latest | jq -r ".tag_name")"

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
    echo "zigbee2mqtt is up-to-date: ${CURRENT_VERSION}"
    exit 0
fi

ZIGBEE2MQTT=https://github.com/Koenkk/zigbee2mqtt/raw/$TARGET_VERSION
curl -LO $ZIGBEE2MQTT/package.json
curl -LO $ZIGBEE2MQTT/package-lock.json

node2nix \
  --composition node.nix \
  --lock package-lock.json \
  --development \
  --no-copy-node-env \
  --node-env ../../development/node-packages/node-env.nix \
  --nodejs-14 \
  --output node-packages.nix

rm package.json package-lock.json

(
    cd ../../../
    update-source-version zigbee2mqtt "$TARGET_VERSION"
)
