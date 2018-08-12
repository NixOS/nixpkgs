{ lib, buildPlatform, buildRustCrate, fetchgit }:

((import ./Cargo.nix { inherit lib buildPlatform buildRustCrate fetchgit; }).cargo_download {}).override {

}
