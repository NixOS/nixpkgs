# Call nix-build on this file to run all tests in this directory
{ pkgs ? import ../../.. {} }:
let
in pkgs.linkFarm "nixpkgs-pkgs-lib-tests" [
]
