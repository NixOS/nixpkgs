{ callPackage, lib, javaPackages }:
# if you add more versions make sure to add to all-packages.nix
let
  versions = lib.importJSON ./versions.json;

  latestVersion = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  escapeVersion = builtins.replaceStrings [ "." ] [ "_" ];

  getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" javaPackages.compiler).headless;

  packages = lib.mapAttrs'
    (version: value: {
      name = "minecraft-server_${escapeVersion version}";
      value = callPackage ./derivation.nix {
        inherit (value) version url sha1;
        jre_headless = getJavaVersion (if value.javaVersion == null then 8 else value.javaVersion); # versions <= 1.6 will default to 8
      };
    })
    versions;
in
packages // {
  minecraft-server = builtins.getAttr "minecraft-server_${escapeVersion latestVersion}" packages;
}
