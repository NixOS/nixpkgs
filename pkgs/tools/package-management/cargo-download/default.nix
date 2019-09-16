{ stdenv, lib, fetchgit, darwin, buildPlatform
, buildRustCrate, buildRustCrateHelpers, defaultCrateOverrides }:

((import ./Cargo.nix {
  inherit lib buildPlatform buildRustCrate buildRustCrateHelpers fetchgit;
  cratesIO = import ./crates-io.nix { inherit lib buildRustCrate buildRustCrateHelpers; };
}).cargo_download {}).override {
  crateOverrides = defaultCrateOverrides // {
    cargo-download = attrs: {
      buildInputs = lib.optional stdenv.isDarwin
        darwin.apple_sdk.frameworks.Security;
    };
  };
}
