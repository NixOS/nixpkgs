{
  lib,
  rustPlatform,
  nix,
  rustfmt,
  clippy,
  mkShell,
  makeWrapper,
  runCommand,
}:
let
  runtimeExprPath = ./src/eval.nix;
  nixpkgsLibPath = ../../../lib;
  testNixpkgsPath = ./tests/mock-nixpkgs.nix;

  # Needed to make Nix evaluation work inside nix builds
  initNix = ''
    export TEST_ROOT=$(pwd)/test-tmp
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_STORE_DIR=$TEST_ROOT/store

    # Ensure that even if tests run in parallel, we don't get an error
    # We'd run into https://github.com/NixOS/nix/issues/2706 unless the store is initialised first
    nix-store --init
  '';

  fs = lib.fileset;

  package =
    rustPlatform.buildRustPackage {
      name = "nixpkgs-check-by-name";
      src = fs.toSource {
        root = ./.;
        fileset = fs.unions [
          ./Cargo.lock
          ./Cargo.toml
          ./src
          ./tests
        ];
      };
      cargoLock.lockFile = ./Cargo.lock;
      nativeBuildInputs = [
        nix
        rustfmt
        clippy
        makeWrapper
      ];
      env.NIX_CHECK_BY_NAME_EXPR_PATH = "${runtimeExprPath}";
      env.NIX_PATH = "test-nixpkgs=${testNixpkgsPath}:test-nixpkgs/lib=${nixpkgsLibPath}";
      preCheck = initNix;
      postCheck = ''
        cargo fmt --check
        cargo clippy -- -D warnings
      '';
      postInstall = ''
        wrapProgram $out/bin/nixpkgs-check-by-name \
          --set NIX_CHECK_BY_NAME_EXPR_PATH "$NIX_CHECK_BY_NAME_EXPR_PATH"
      '';
      passthru.shell = mkShell {
        env.NIX_CHECK_BY_NAME_EXPR_PATH = toString runtimeExprPath;
        env.NIX_PATH = "test-nixpkgs=${toString testNixpkgsPath}:test-nixpkgs/lib=${toString nixpkgsLibPath}";
        inputsFrom = [ package ];
      };

      # Tests the tool on the current Nixpkgs tree, this is a good sanity check
      passthru.tests.nixpkgs = runCommand "test-nixpkgs-check-by-name" {
        nativeBuildInputs = [
          package
          nix
        ];
        nixpkgsPath = lib.cleanSource ../../..;
      } ''
        ${initNix}
        nixpkgs-check-by-name --base "$nixpkgsPath" "$nixpkgsPath"
        touch $out
      '';
    };
in
package
