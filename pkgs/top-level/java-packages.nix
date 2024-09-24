{ pkgs }:

with pkgs;

let
  openjfx11 = callPackage ../development/compilers/openjdk/openjfx/11 { };
  openjfx17 = callPackage ../development/compilers/openjdk/openjfx/17 { };
  openjfx21 = callPackage ../development/compilers/openjdk/openjfx/21 { };
  openjfx22 = callPackage ../development/compilers/openjdk/openjfx/22 { };

in {
  inherit openjfx11 openjfx17 openjfx21 openjfx22;

  compiler = let
    mkOpenjdk = path-linux: path-darwin: args:
      if stdenv.hostPlatform.isLinux
      then mkOpenjdkLinuxOnly path-linux args
      else let
        openjdk = callPackage path-darwin {};
      in openjdk // { headless = openjdk; };

    mkOpenjdkLinuxOnly = path-linux: args: let
      openjdk = callPackage path-linux (args);
    in assert stdenv.hostPlatform.isLinux; openjdk // {
      headless = openjdk.override { headless = true; };
    };

  in rec {
    corretto11 = callPackage ../development/compilers/corretto/11.nix { };
    corretto17 = callPackage ../development/compilers/corretto/17.nix { };
    corretto21 = callPackage ../development/compilers/corretto/21.nix { };

    openjdk8-bootstrap = temurin-bin.jdk-8;

    openjdk11-bootstrap = temurin-bin.jdk-11;

    openjdk17-bootstrap = temurin-bin.jdk-17;

    openjdk8 = mkOpenjdk
      ../development/compilers/openjdk/8.nix
      ../development/compilers/zulu/8.nix
      { };

    openjdk11 = mkOpenjdk
      ../development/compilers/openjdk/11.nix
      ../development/compilers/zulu/11.nix
      { openjfx = openjfx11; };

    openjdk17 = mkOpenjdk
      ../development/compilers/openjdk/17.nix
      ../development/compilers/zulu/17.nix
      {
        inherit openjdk17-bootstrap;
        openjfx = openjfx17;
      };

    openjdk21 = mkOpenjdk
      ../development/compilers/openjdk/21.nix
      ../development/compilers/zulu/21.nix
      {
        openjdk21-bootstrap = temurin-bin.jdk-21;
        openjfx = openjfx21;
      };

    openjdk22 = mkOpenjdk
      ../development/compilers/openjdk/22.nix
      ../development/compilers/zulu/22.nix
      {
        openjdk22-bootstrap = temurin-bin.jdk-22;
        openjfx = openjfx22;
      };

    temurin-bin = recurseIntoAttrs (callPackage (
      if stdenv.hostPlatform.isLinux
      then ../development/compilers/temurin-bin/jdk-linux.nix
      else ../development/compilers/temurin-bin/jdk-darwin.nix
    ) {});

    semeru-bin = recurseIntoAttrs (callPackage (
      if stdenv.hostPlatform.isLinux
      then ../development/compilers/semeru-bin/jdk-linux.nix
      else ../development/compilers/semeru-bin/jdk-darwin.nix
    ) {});
  };
}
// lib.optionalAttrs config.allowAliases {
  jogl_2_4_0 = throw "'jogl_2_4_0' is renamed to/replaced by 'jogl'";
  mavenfod = throw "'mavenfod' is renamed to/replaced by 'maven.buildMavenPackage'";
}
