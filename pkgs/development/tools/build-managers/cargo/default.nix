{ stdenv, callPackage, rustc, makeRustPlatform, recurseIntoAttrs }:

let
  cargoBootstrap = callPackage ./bootstrap.nix {};
  rustPlatformBootstrap = recurseIntoAttrs (makeRustPlatform cargoBootstrap rustPlatformBootstrap);
in
callPackage ./generic.nix rec {
  version = "0.10.0";
  srcRev = "refs/tags/${version}";
  srcSha = "06scvx5qh60mgvlpvri9ig4np2fsnicsfd452fi9w983dkxnz4l2";
  depsSha256 = "0js4697n7v93wnqnpvamhp446w58llj66za5hkd6wannmc0gsy3b";
  inherit rustc;
  rustPlatform = rustPlatformBootstrap;
}
