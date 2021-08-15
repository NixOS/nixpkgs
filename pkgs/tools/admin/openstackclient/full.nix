{ callPackage }:
let
  inherit (callPackage ./base.nix { }) withPlugins;
in
  withPlugins (availablePlugins: builtins.attrValues availablePlugins)
