#!/usr/bin/env bash
set -eu -o pipefail
cd "$( dirname "${BASH_SOURCE[0]}" )"
rm -f ./node-env.nix
<<<<<<< HEAD
src="$(nix-build --expr 'let pkgs = import ../../../.. {}; meta = (pkgs.lib.importJSON ./netlify-cli.json); in pkgs.fetchFromGitHub { inherit (meta) owner repo rev hash; }')"
=======
src="$(nix-build --expr 'let pkgs = import ../../../.. {}; meta = (pkgs.lib.importJSON ./netlify-cli.json); in pkgs.fetchFromGitHub { inherit (meta) owner repo rev sha256; }')"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
echo $src
node2nix \
  --input $src/package.json \
  --lock $src/npm-shrinkwrap.json \
  --output node-packages.nix \
  --composition composition.nix \
  --node-env node-env.nix \
<<<<<<< HEAD
  --nodejs-18 \
=======
  --nodejs-16 \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ;
