#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

tag="v0.1.1"
u="https://gitlab.com/mx-puppet/discord/mx-puppet-discord/-/raw/$tag"
# Download package.json and patch in @discordjs/opus optional dependency
curl $u/package.json |
    sed 's|"typescript": *"\^\?3\.[^"]*"|"typescript": "^4.8.3"|' |  # TODO: remove when newer typescript version pinned
    sed 's|\("dependencies": *{\)|\1\n"@discordjs/opus": "^0.8.0",|' >package.json

node2nix \
  --nodejs-14 \
  --node-env ../../development/node-packages/node-env.nix \
  --input package.json \
  --strip-optional-dependencies \
  --output node-packages.nix \
  --composition node-composition.nix \
  --registry https://registry.npmjs.org \
  --registry https://gitlab.com/api/v4/packages/npm \
  --registry-scope '@mx-puppet'

sed -i 's|<nixpkgs>|../../..|' node-composition.nix

rm -f package.json
