#!/usr/bin/env bash

ROOT="$(realpath "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"/../../../..)"

$(nix-build $ROOT -A  nodePackages.node2nix --no-out-link)/bin/node2nix \
  --nodejs-18 \
  --node-env ../../../development/node-packages/node-env.nix \
  --development \
  --lock ./package-lock-temp.json \
  --output node-packages.nix \
  --composition node-composition.nix
