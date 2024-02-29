# Entrypoint for Nixpkgs release tests
args@{ pkgs-path ? ../../..
, pkgs ? import pkgs-path {}
, lib ? pkgs.lib
, nix ? pkgs.nix
}:

# This could be extended with more tests in the future
import ../eval/all-attrpaths.nix { inherit pkgs-path pkgs lib nix; }
