{ stdenv, pkgs }:

let
  nodePackages = import ./node-packages.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.base16-builder
