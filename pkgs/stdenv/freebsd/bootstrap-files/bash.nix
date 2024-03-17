{ system }: ((import <nixpkgs> {}).callPackage ({ stdenv, pkgsCross, runCommand, lib, stdenvAdapters, buildPackages, ... }:
let
  pkgs = pkgsCross.${system};
  static = import ./static.nix { inherit stdenvAdapters pkgs; };
in
  runCommand "${system}-bash" {} "cp ${static.bash}/bin/bash $out"
) {})
