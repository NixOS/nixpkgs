{ nixpkgs, pkgs }:

with pkgs;

let
  nixCommand = name: command:
    runCommand name { buildInputs = [ nix ]; } ''
      datadir="${nix}/share"
      export TEST_ROOT=$(pwd)/test-tmp
      export NIX_BUILD_HOOK=
      export NIX_CONF_DIR=$TEST_ROOT/etc
      export NIX_DB_DIR=$TEST_ROOT/db
      export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
      export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
      export NIX_MANIFESTS_DIR=$TEST_ROOT/var/nix/manifests
      export NIX_STATE_DIR=$TEST_ROOT/var/nix
      export NIX_STORE_DIR=$TEST_ROOT/store
      export PAGER=cat
      cacheDir=$TEST_ROOT/binary-cache
      nix-store --init

      cd ${nixpkgs}/pkgs/test/security
      ${command}
      touch $out
    '';
in

{
  check-quickfix = import ./check-quickfix.nix;
  onefix-noop = nixCommand "onefix-noop" ''
    nix-instantiate --timeout 60 ./onefix-noop.nix --eval-only
  '';
  abifix-noop = nixCommand "abifix-noop" ''
    nix-instantiate --timeout 60 ./abifix-noop.nix --eval-only
  '';
}
