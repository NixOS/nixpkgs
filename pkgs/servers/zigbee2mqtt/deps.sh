#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix nodejs-12_x
VERSION=1.14.1
ZIGBEE2MQTT=https://raw.githubusercontent.com/Koenkk/zigbee2mqtt/$VERSION

wget $ZIGBEE2MQTT/package.json
wget $ZIGBEE2MQTT/npm-shrinkwrap.json

node2nix --nodejs-12 \
  -l npm-shrinkwrap.json \
  -c node.nix \
  --bypass-cache \
  --no-copy-node-env \
  --node-env ../../development/node-packages/node-env.nix
rm package.json npm-shrinkwrap.json
