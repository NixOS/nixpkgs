#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# No official release
rev=bb6438a504182a7a64048b992179427587ccfded
u=https://raw.githubusercontent.com/matrix-discord/mx-puppet-discord/$rev
# Download package.json and package-lock.json
curl -O $u/package.json
curl $u/package-lock.json |
  sed -e 's|git+ssh://git@|git+https://|g' > package-lock.json

node2nix \
  --nodejs-14 \
  --node-env ../../development/node-packages/node-env.nix \
  --input package.json \
  --lock package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix

sed -i 's|<nixpkgs>|../../..|' node-composition.nix

rm -f package.json package-lock.json
