let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
in
{
  callPackage,
  javaPackages,
  lib,
  ...
}:
let
  latestVersion = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  escapeVersion = builtins.replaceStrings [ "." ] [ "_" ];
  getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" javaPackages.compiler).headless;

  packages = lib.mapAttrs' (version: value: {
    name = "papermc-${escapeVersion version}";
    value = callPackage ./derivation.nix {
      inherit (value) url version hash;
      jre = getJavaVersion value.javaVersion;
    };
  }) versions;
in
lib.recurseIntoAttrs (
  packages
  // {
    papermc = builtins.getAttr "papermc-${escapeVersion latestVersion}" packages;
  }
)
