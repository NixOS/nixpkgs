{
  runtimeShell,
  lib,
  writeScript,
  bundix,
  bundler,
  coreutils,
  git,
  nix,
  nixfmt,
}:

attrPath:

let
  updateScript = writeScript "bundler-update-script" ''
    #!${runtimeShell}
    PATH=${
      lib.makeBinPath [
        bundler
        bundix
        coreutils
        git
        nix
        nixfmt
      ]
    }
    set -o errexit
    set -o nounset
    set -o pipefail

    attrPath=$1

    toplevel=$(git rev-parse --show-toplevel)
    position=$(nix --extra-experimental-features nix-command eval -f "$toplevel" --raw "$attrPath.meta.position")
    gemdir=$(dirname "$position")

    cd "$gemdir"

    rm -f gemset.nix Gemfile.lock
    export BUNDLE_FORCE_RUBY_PLATFORM=1
    bundler lock --update
    bundix
    nixfmt gemset.nix
  '';
in
[
  updateScript
  attrPath
]
