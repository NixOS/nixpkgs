#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yarn2nix curl

set -euo pipefail

version=$(< default.nix grep version | head -n1 | cut -d= -f2 | tr -d '" ;')

yarn2nix \
  --lockfile <(curl https://raw.githubusercontent.com/tsl0922/ttyd/$version/html/yarn.lock) \
  --no-patch --builtin-fetchgit > yarn.nix
