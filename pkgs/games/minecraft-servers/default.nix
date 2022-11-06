{ callPackage, lib, javaPackages }:
let
  servers = lib.importJSON ./servers.json;
  vanillaServers = lib.filterAttrs (n: v: lib.hasPrefix "vanilla-" n) servers;

  latestVersion = lib.last (builtins.sort lib.versionOlder (builtins.catAttrs "version" (lib.collect (x: x ? version) vanillaServers)));
  escapeVersion = builtins.replaceStrings [ "." ] [ "-" ];

  getJavaVersion = v: (builtins.getAttr "openjdk${toString v}" javaPackages.compiler).headless;

  packages = lib.mapAttrs'
    (server: value: {
      name = "${escapeVersion server}";
      value = callPackage ./derivation.nix {
        inherit (value) version url sha1 modloader;
        jre_headless = getJavaVersion (if value.javaVersion == null then 8 else value.javaVersion); # versions <= 1.6 will default to 8
      };
    })
    servers;
in
lib.recurseIntoAttrs (
  packages // {
    vanilla = builtins.getAttr "vanilla-${lib.concatStringsSep "-" (lib.take 2 (lib.splitString "." latestVersion))}" packages;
  }
)
