#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# XXX: --development is given here because we need access to gulp in order to build OnlyKey.
<<<<<<< HEAD
exec node2nix --nodejs-18 --development -i package.json -c onlykey.nix -e ../../../development/node-packages/node-env.nix --no-copy-node-env
=======
exec node2nix --nodejs-14 --development -i package.json -c onlykey.nix -e ../../../development/node-packages/node-env.nix --no-copy-node-env
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
