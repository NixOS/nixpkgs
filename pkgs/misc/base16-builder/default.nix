{ stdenv, pkgs }:

let
  nodePackages = import ./node-packages.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    nodejs = pkgs.nodejs_22;
  };
in
nodePackages.base16-builder
