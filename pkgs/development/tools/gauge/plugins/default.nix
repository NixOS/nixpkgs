{ lib, pkgs }:
lib.makeScope pkgs.newScope (final: let
  inherit (final) callPackage;
in {
  makeGaugePlugin = callPackage ./make-gauge-plugin.nix { };
  html-report = callPackage ./html-report { };
  java = callPackage ./java { };
})
