{ stdenv, lib, fetchgit, darwin, buildPlatform
, buildRustCrate, defaultCrateOverrides }:

((import ./Cargo.nix { inherit lib buildPlatform buildRustCrate fetchgit; }).cargo_download {}).override {
  crateOverrides = defaultCrateOverrides // {
    cargo-download = attrs: {
      buildInputs = lib.optional stdenv.isDarwin
        darwin.apple_sdk.frameworks.Security;
    };
  };
}
