{
  callPackage,
  lib,
}:
let
  older = a: b: lib.versionOlder a.version b.version;
  escapeVersion = builtins.replaceStrings [ "." ] [ "_" ];

  versions = builtins.sort older (lib.importJSON ./versions.json);
  latest = lib.last versions;

  versions' = lib.listToAttrs (
    map (x: lib.nameValuePair "fabric-${escapeVersion x.version}" x) versions
  );

  packages = lib.mapAttrs (_: args: callPackage ./derivation.nix args) versions';
in
lib.recurseIntoAttrs (
  packages
  // {
    fabric = builtins.getAttr "fabric-${escapeVersion latest.version}" packages;
  }
)
