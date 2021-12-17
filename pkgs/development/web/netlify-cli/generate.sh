#!/usr/bin/env bash
set -eu -o pipefail
cd "$( dirname "${BASH_SOURCE[0]}" )"
rm -f ./node-env.nix
src="$(nix-build --expr '(import ../../../.. {}).fetchFromGitHub (lib.importJSON ./netlify-cli.json)')"
echo $src
node2nix \
  --input $src/package.json \
  --lock $src/npm-shrinkwrap.json \
  --output node-packages.nix \
  --composition composition.nix \
  --node-env node-env.nix \
  --nodejs-14 \
  ;
