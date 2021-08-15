{ callPackage, lib }:
let
  inherit (callPackage ./base.nix { }) withPlugins;
in
  withPlugins (lib.const [])
