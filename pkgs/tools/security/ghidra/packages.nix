# Construct the package set from some ad-hoc / slightly structured layers.
{lib, callPackage}:
let
  baseLayer = ./layers/0_base.nix; # Functionality pertaining to package sets in general
  layers = [
    ./layers/1_util.nix # Functions for constructing Ghidra packages
    ./layers/2_base_packages.nix # The base Ghidra packages (Ghidra and GhidraDev, ...)
    ./layers/3_packages.nix # Plugin packages
    ];
  mkBase = lib.makeExtensible (callPackage baseLayer {});
  extend = layer: layer.extend; # A definition we can use in fold
in
  lib.foldl extend mkBase (map import layers)
