{ newScope, pkgs }:

let
  callPackage = newScope (pkgs // plugins);
  plugins = import ./plugins.nix { inherit callPackage; };
in
plugins
