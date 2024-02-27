{ lib, pkgs }:
lib.makeScope pkgs.newScope (final: let
  inherit (final) callPackage;
in {
  makeGaugePlugin = callPackage ./make-gauge-plugin.nix { };
  java = callPackage ./java { };
})
