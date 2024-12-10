{
  callPackage,
  lib,
  javaPackages,
}:
let
  versions = lib.importJSON ./versions.json;

  latestVersion = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  escapeVersion = builtins.replaceStrings [ "." ] [ "-" ];

  getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" javaPackages.compiler).headless;

  packages = lib.mapAttrs' (version: value: {
    name = "vanilla-${escapeVersion version}";
    value = callPackage ./derivation.nix {
      inherit (value) version url sha1;
      jre_headless = getJavaVersion (if value.javaVersion == null then 8 else value.javaVersion); # versions <= 1.6 will default to 8
    };
  }) versions;
in
lib.recurseIntoAttrs (
  packages
  // {
    vanilla = builtins.getAttr "vanilla-${escapeVersion latestVersion}" packages;
  }
)
