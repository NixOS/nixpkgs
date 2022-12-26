{ lib, newScope, callPackage, ghidra }:

lib.makeScope newScope (self: {
  inherit (callPackage ./build-extension.nix { inherit ghidra; }) buildGhidraExtension buildGhidraScripts;
})
