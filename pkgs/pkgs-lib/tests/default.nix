# Call nix-build on this file to run all tests in this directory
{ pkgs ? import ../../.. {} }:
pkgs.linkFarm "nixpkgs-pkgs-lib-tests" [
  { name = "formats"; path = import ./formats.nix { inherit pkgs; }; }
]
