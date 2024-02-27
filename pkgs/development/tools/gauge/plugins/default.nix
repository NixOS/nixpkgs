{ lib, pkgs }:
lib.makeScope pkgs.newScope (final: {
  makeGaugePlugin = final.callPackage ./make-gauge-plugin.nix { };
  java = final.callPackage ./java { };
})
