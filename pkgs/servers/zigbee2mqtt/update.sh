#! /usr/bin/env nix-shell
#! nix-shell -i sh -p yarn yarn2nix python3
curl https://raw.githubusercontent.com/Koenkk/zigbee2mqtt/master/package.json > package.json
yarn
yarn2nix > yarn.nix
