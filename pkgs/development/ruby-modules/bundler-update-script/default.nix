{ runtimeShell, lib, writeScript, bundix, bundler, coreutils, git, nix }:

attrPath:

let
  updateScript = writeScript "bundler-update-script" ''
    #!${runtimeShell}
    PATH=${lib.makeBinPath [ bundler bundix coreutils git nix ]}
    set -o errexit
    set -o nounset
    set -o pipefail

    attrPath=$1

    toplevel=$(git rev-parse --show-toplevel)
    position=$(nix --extra-experimental-features nix-command eval -f "$toplevel" --raw "$attrPath.meta.position")
    gemdir=$(dirname "$position")

    cd "$gemdir"

    bundler lock --update
    bundix
  '';
in [ updateScript attrPath ]
