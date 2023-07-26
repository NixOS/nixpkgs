{ lib, callPackage }:

let
  versions = lib.importJSON ./info.json;
in
  lib.mapAttrs' (version: info:
    lib.nameValuePair "electron_${version}" (
      lib.warnIf (lib.versionOlder info.chromium.version info.chrome) "Electron ${info.version} is being built with a mismatched chromium patch version ${info.chromium.version} < ${info.chrome}" (
        callPackage ./common.nix { inherit info; }
      )
    )
  ) versions
