{ runtimeShell, lib, writeScript, bundix, bundler, bundler-audit, coreutils, git, nix_2_3 }:

attrPath:

let
  updateScript = writeScript "bundler-update-script" ''
    #!${runtimeShell}
    PATH=${lib.makeBinPath [ bundler bundler-audit bundix coreutils git nix_2_3 ]}
    set -o errexit
    set -o nounset
    set -o pipefail

    attrPath=$1

    toplevel=$(git rev-parse --show-toplevel)
    position=$(nix eval -f "$toplevel" --raw "$attrPath.meta.position")
    gemdir=$(dirname "$position")

    cd "$gemdir"

    bundler lock --update
    bundler-audit check --update
    bundix
  '';
in [ updateScript attrPath ]
