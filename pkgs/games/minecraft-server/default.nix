{ callPackage, lib }:
# if you add more versions make sure to add to all-packages.nix
let
  versions = lib.importJSON ./versions.json;
  latestVersion = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  escapeVersion = builtins.replaceStrings [ "." ] [ "_" ];

  packages = lib.mapAttrs'
    (version: value: {
      name = "minecraft-server_${escapeVersion version}";
      value = callPackage ./derivation.nix { inherit (value) version url sha1; };
    })
    versions;
in
packages // {
  minecraft-server = builtins.getAttr "minecraft-server_${escapeVersion latestVersion}" packages;
}
