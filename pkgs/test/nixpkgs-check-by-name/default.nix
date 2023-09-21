{
  lib,
  rustPlatform,
  nix,
  rustfmt,
  clippy,
  mkShell,
}:
let
  package =
    rustPlatform.buildRustPackage {
      name = "nixpkgs-check-by-name";
      src = lib.cleanSource ./.;
      cargoLock.lockFile = ./Cargo.lock;
      nativeBuildInputs = [
        nix
        rustfmt
        clippy
      ];
      # Needed to make Nix evaluation work inside the nix build
      preCheck = ''
        export TEST_ROOT=$(pwd)/test-tmp
        export NIX_CONF_DIR=$TEST_ROOT/etc
        export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
        export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
        export NIX_STATE_DIR=$TEST_ROOT/var/nix
        export NIX_STORE_DIR=$TEST_ROOT/store

        # cargo tests run in parallel by default, which would then run into
        # https://github.com/NixOS/nix/issues/2706 unless the store is initialised first
        nix-store --init
      '';
      postCheck = ''
        cargo fmt --check
        cargo clippy -- -D warnings
      '';
      passthru.shell = mkShell {
        inputsFrom = [ package ];
      };
    };
in
package
