<<<<<<< HEAD
{ runtimeShell, lib, writeScript, bundix, bundler, coreutils, git, nix }:
=======
{ runtimeShell, lib, writeScript, bundix, bundler, bundler-audit, coreutils, git, nix }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

attrPath:

let
  updateScript = writeScript "bundler-update-script" ''
    #!${runtimeShell}
<<<<<<< HEAD
    PATH=${lib.makeBinPath [ bundler bundix coreutils git nix ]}
=======
    PATH=${lib.makeBinPath [ bundler bundler-audit bundix coreutils git nix ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    set -o errexit
    set -o nounset
    set -o pipefail

    attrPath=$1

    toplevel=$(git rev-parse --show-toplevel)
    position=$(nix --extra-experimental-features nix-command eval -f "$toplevel" --raw "$attrPath.meta.position")
    gemdir=$(dirname "$position")

    cd "$gemdir"

    bundler lock --update
<<<<<<< HEAD
=======
    bundler-audit check --update
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    bundix
  '';
in [ updateScript attrPath ]
