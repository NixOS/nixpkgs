{ lib, callPackage }:

let
  versions = lib.importJSON ./info.json;
in
  lib.mapAttrs' (version: info:
    lib.nameValuePair "electron_${version}" (
      let
        electron-unwrapped = callPackage ./common.nix { inherit info; };
      in callPackage ./wrapper.nix { inherit electron-unwrapped; }
    )
  ) versions
