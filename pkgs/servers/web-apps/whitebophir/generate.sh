#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix
# shellcheck shell=bash
set -euo pipefail

node2nix \
     --input node-packages.json \
     --output node-packages-generated.nix \
     --composition node-packages.nix \
     --node-env ../../../development/node-packages/node-env.nix
