{
  lib,
  rustPlatform,
  nix,
  rustfmt,
  clippy,
  mkShell,
  makeWrapper,
}:
let
  runtimeExprPath = ./src/eval.nix;
  package =
    rustPlatform.buildRustPackage {
      name = "nixpkgs-check-by-name";
      src = lib.cleanSource ./.;
      cargoLock.lockFile = ./Cargo.lock;
      nativeBuildInputs = [
        nix
        rustfmt
        clippy
        makeWrapper
      ];
      env.NIX_CHECK_BY_NAME_EXPR_PATH = "${runtimeExprPath}";
      # Needed to make Nix evaluation work inside the nix build
      preCheck = ''
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
        inputsFrom = [ package ];
      };
    };
in
package
