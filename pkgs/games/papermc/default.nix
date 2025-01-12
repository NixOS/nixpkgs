let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
in
{ callPackage, lib, ... }:
let
  latestVersion = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  escapeVersion = builtins.replaceStrings [ "." ] [ "_" ];
  packages = lib.mapAttrs'
    (version: value: {
      name = "papermc-${escapeVersion version}";
      value = callPackage ./derivation.nix { inherit (value) version hash; };
    })
    versions;
in
lib.recurseIntoAttrs (packages // {
  papermc = builtins.getAttr "papermc-${escapeVersion latestVersion}" packages;
})
