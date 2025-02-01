# Adapted from lib/tests/release.nix
{ pkgs-path ? ../../..
, pkgs ? import pkgs-path {}
, lib ? pkgs.lib
, nix ? pkgs.nix
}:

#
# This verifies that release-attrpaths-superset.nix does not encounter
# infinite recursion or non-tryEval-able failures.
#
pkgs.runCommand "all-attrs-eval-under-tryEval" {
  nativeBuildInputs = [
    nix
    pkgs.gitMinimal
  ] ++ lib.optional pkgs.stdenv.isLinux pkgs.inotify-tools;
  strictDeps = true;

  src = with lib.fileset; toSource {
    root = pkgs-path;
    fileset = unions [
      ../../../default.nix
      ../../../doc
      ../../../lib
      ../../../maintainers
      ../../../nixos
      ../../../pkgs
      ../../../.version
    ];
  };
}
''
  datadir="${nix}/share"
  export TEST_ROOT=$(pwd)/test-tmp
  export HOME=$(mktemp -d)
  export NIX_BUILD_HOOK=
  export NIX_CONF_DIR=$TEST_ROOT/etc
  export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
  export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
  export NIX_STATE_DIR=$TEST_ROOT/var/nix
  export NIX_STORE_DIR=$TEST_ROOT/store
  export PAGER=cat
  cacheDir=$TEST_ROOT/binary-cache

  nix-store --init

  echo "Running pkgs/top-level/release-attrpaths-superset.nix"
  nix-instantiate --eval --strict --json $src/pkgs/top-level/release-attrpaths-superset.nix -A names > /dev/null

  mkdir $out
  echo success > $out/${nix.version}
''
