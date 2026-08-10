# Tests for the evaluation behavior of the Nixpkgs tree itself: they run a
# Nix evaluator against Nixpkgs inside the build sandbox, using a scratch
# store (NIX_STORE_DIR) to observe what evaluation writes to it.
#
# Evaluation performance *measurements* tracked by Hydra live in
# pkgs/top-level/metrics.nix instead.
{
  lib,
  nix,
  runCommand,
  path,
}:

let
  nixpkgs = lib.cleanSource path;

  supportedSystems = builtins.fromJSON (
    builtins.readFile ../../top-level/release-supported-systems.json
  );

  tests = {
    # Merely evaluating package metadata (such as `hello.name`) must not
    # instantiate any derivations, i.e. no .drv files may be written to the
    # store. This regressed in the past through top-level assertions comparing
    # derivations, which forces their outPaths:
    # https://github.com/NixOS/nixpkgs/pull/539613
    lazy-metadata = runCommand "test-eval-lazy-metadata" { nativeBuildInputs = [ nix ]; } ''
      export NIX_STORE_DIR=$(mktemp -d)
      export NIX_STATE_DIR=$(mktemp -d)
      nix-store --init

      for system in ${toString supportedSystems}; do
        echo "checking that metadata evaluation on $system does not write to the store"
        # --read-write-mode is required: in the default read-only mode of
        # `nix-instantiate --eval`, outPaths are computed without writing
        # .drv files, which would mask the regression.
        nix-instantiate --eval --strict --show-trace --read-write-mode \
          ${nixpkgs} -A hello.name --argstr system "$system" \
          --option allow-import-from-derivation false > /dev/null
      done

      drvFiles=$(find "$NIX_STORE_DIR" -name '*.drv')
      if [[ -n $drvFiles ]]; then
        echo "Evaluating package metadata wrote $(echo "$drvFiles" | wc -l) .drv files to the store, for example:"
        echo "$drvFiles" | head -n 10
        echo "Most likely something forces derivation comparisons (and thus their outPaths) during evaluation of the Nixpkgs top level."
        exit 1
      fi

      touch $out
    '';
  };
in
runCommand "test-eval-perf"
  {
    passthru = tests;
    # The tests check all supported systems in a single build, so there is no
    # point in Hydra building them more than once.
    meta.hydraPlatforms = [ "x86_64-linux" ];
  }
  ''
    echo ${toString (lib.attrValues tests)} > $out
  ''
