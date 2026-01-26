{
  callPackage,
  lib,
}:
let
  escapeVersion = lib.replaceString "." "_";

  versions = lib.sort (a: b: lib.versionOlder a.version b.version) (lib.importJSON ./versions.json);

  latest = lib.last versions;

  versions' = lib.listToAttrs (
    map (x: lib.nameValuePair "fabric-${escapeVersion x.version}" x) versions
  );

  packages = lib.mapAttrs (_: callPackage ./derivation.nix) versions';
in
lib.recurseIntoAttrs (
  packages
  // {
    fabric = packages."fabric-${escapeVersion latest.version}";
  }
)
