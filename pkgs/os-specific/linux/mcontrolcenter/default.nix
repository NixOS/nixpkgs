{ pkgs ? import <nixpkgs> {} }:
pkgs.libsForQt5.callPackage ./derivation.nix {}
