#!/usr/bin/env bash

ROOT="$(realpath "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"/../../../..)"

$(nix-build $ROOT -A  nodePackages.node2nix --no-out-link)/bin/node2nix \
  --nodejs-14 \
  --node-env ../../../development/node-packages/node-env.nix \
  --development \
  --output node-packages.nix \
  --composition node-composition.nix
# removed temporarily because of https://github.com/svanderburg/node2nix/issues/312
# --lock ./package-lock-temp.json \
