{ pkgs }:

with pkgs;

let
  openjfx11 = callPackage ../development/compilers/openjdk/openjfx/11.nix { };
  openjfx15 = callPackage ../development/compilers/openjdk/openjfx/15.nix { };
  openjfx17 = callPackage ../development/compilers/openjdk/openjfx/17.nix { };
  openjfx19 = callPackage ../development/compilers/openjdk/openjfx/19.nix { };
  openjfx20 = callPackage ../development/compilers/openjdk/openjfx/20.nix { };
  openjfx21 = callPackage ../development/compilers/openjdk/openjfx/21.nix { };

in {
  inherit openjfx11 openjfx15 openjfx17 openjfx19 openjfx20 openjfx21;

  compiler = let

    gnomeArgs = {
      inherit (gnome2) GConf gnome_vfs;
    };

    bootstrapArgs = gnomeArgs // {
      openjfx = openjfx11; /* need this despite next line :-( */
      enableJavaFX = false;
      headless = true;
    };

    mkAdoptopenjdk = path-linux: path-darwin: let
      package-linux  = import path-linux { inherit stdenv lib; };
      package-darwin = import path-darwin { inherit lib; };
      package = if stdenv.isLinux
        then package-linux
        else package-darwin;
    in {
      inherit package-linux package-darwin;
      __attrsFailEvaluation = true;

      jdk-hotspot = callPackage package.jdk-hotspot {};
      jre-hotspot = callPackage package.jre-hotspot {};
    } // lib.optionalAttrs (package?jdk-openj9) {
      jdk-openj9  = callPackage package.jdk-openj9  {};
    } // lib.optionalAttrs (package?jre-openj9) {
      jre-openj9  = callPackage package.jre-openj9  {};
    };

    mkBootstrap = adoptopenjdk: path: args:
      /* adoptopenjdk not available for i686, so fall back to our old builds for bootstrapping */
      if   !stdenv.hostPlatform.isi686
      then
        # only linux has the gtkSupport option
        if stdenv.isLinux
        then adoptopenjdk.jdk-hotspot.override { gtkSupport = false; }
        else adoptopenjdk.jdk-hotspot
      else callPackage path args;

    mkOpenjdk = path-linux: path-darwin: args:
      if stdenv.isLinux
      then mkOpenjdkLinuxOnly path-linux args
      else let
        openjdk = callPackage path-darwin {};
      in openjdk // { headless = openjdk; };

    mkOpenjdkLinuxOnly = path-linux: args: let
      openjdk = callPackage path-linux  (gnomeArgs // args);
    in assert stdenv.isLinux; openjdk // {
      headless = openjdk.override { headless = true; };
    };

  in rec {
    adoptopenjdk-8 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk8-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk8-darwin.nix;

    adoptopenjdk-11 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk11-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk11-darwin.nix;

    adoptopenjdk-13 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk13-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk13-darwin.nix;

    adoptopenjdk-14 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk14-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk14-darwin.nix;

    adoptopenjdk-15 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk15-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk15-darwin.nix;

    adoptopenjdk-16 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk16-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk16-darwin.nix;

    adoptopenjdk-17 = mkAdoptopenjdk
      ../development/compilers/adoptopenjdk-bin/jdk17-linux.nix
      ../development/compilers/adoptopenjdk-bin/jdk17-darwin.nix;

    corretto11 = callPackage ../development/compilers/corretto/11.nix { };
    corretto17 = callPackage ../development/compilers/corretto/17.nix { };
    corretto19 = callPackage ../development/compilers/corretto/19.nix { };

    openjdk8-bootstrap = mkBootstrap adoptopenjdk-8
      ../development/compilers/openjdk/bootstrap.nix
      { version = "8"; };

    openjdk11-bootstrap = mkBootstrap adoptopenjdk-11
      ../development/compilers/openjdk/bootstrap.nix
      { version = "10"; };

    openjdk13-bootstrap = mkBootstrap adoptopenjdk-13
      ../development/compilers/openjdk/12.nix
      (bootstrapArgs // {
        inherit openjdk11-bootstrap;
        /* build segfaults with gcc9 or newer, so use gcc8 like Debian does */
        stdenv = gcc8Stdenv;
      });

    openjdk14-bootstrap = mkBootstrap adoptopenjdk-14
      ../development/compilers/openjdk/13.nix
      (bootstrapArgs // {
        inherit openjdk13-bootstrap;
      });

    openjdk15-bootstrap = mkBootstrap adoptopenjdk-15
      ../development/compilers/openjdk/14.nix
      (bootstrapArgs // {
        inherit openjdk14-bootstrap;
      });

    openjdk16-bootstrap = mkBootstrap adoptopenjdk-16
      ../development/compilers/openjdk/15.nix
      (bootstrapArgs // {
        inherit openjdk15-bootstrap;
      });

    openjdk17-bootstrap = mkBootstrap adoptopenjdk-17
      ../development/compilers/openjdk/16.nix
      (bootstrapArgs // {
        inherit openjdk16-bootstrap;
      });

    openjdk18-bootstrap = mkBootstrap adoptopenjdk-17
      ../development/compilers/openjdk/17.nix
      (bootstrapArgs // {
        inherit openjdk17-bootstrap;
      });

    openjdk8 = mkOpenjdk
      ../development/compilers/openjdk/8.nix
      ../development/compilers/zulu/8.nix
      { };

    openjdk11 = mkOpenjdk
      ../development/compilers/openjdk/11.nix
      ../development/compilers/zulu/11.nix
      { openjfx = openjfx11; };

    openjdk12 = mkOpenjdkLinuxOnly ../development/compilers/openjdk/12.nix {
        /* build segfaults with gcc9 or newer, so use gcc8 like Debian does */
        stdenv = gcc8Stdenv;
        openjfx = openjfx11;
    };

    openjdk13 = mkOpenjdkLinuxOnly ../development/compilers/openjdk/13.nix {
      inherit openjdk13-bootstrap;
      openjfx = openjfx11;
    };

    openjdk14 = mkOpenjdkLinuxOnly ../development/compilers/openjdk/14.nix {
      inherit openjdk14-bootstrap;
      openjfx = openjfx11;
    };

    openjdk15 = mkOpenjdkLinuxOnly ../development/compilers/openjdk/15.nix {
      inherit openjdk15-bootstrap;
      openjfx = openjfx15;
    };

    openjdk16 = mkOpenjdkLinuxOnly ../development/compilers/openjdk/16.nix {
      inherit openjdk16-bootstrap;
      openjfx = openjfx15;
    };

    openjdk17 = mkOpenjdk
      ../development/compilers/openjdk/17.nix
      ../development/compilers/zulu/17.nix
      {
        inherit openjdk17-bootstrap;
        openjfx = openjfx17;
      };

    openjdk18 = mkOpenjdk
      ../development/compilers/openjdk/18.nix
      ../development/compilers/zulu/18.nix
      {
        inherit openjdk18-bootstrap;
        openjfx = openjfx17;
      };

    openjdk19 = mkOpenjdk
      ../development/compilers/openjdk/19.nix
      ../development/compilers/zulu/19.nix
      {
        openjdk19-bootstrap = temurin-bin.jdk-19;
        openjfx = openjfx19;
      };

    openjdk20 = mkOpenjdk
      ../development/compilers/openjdk/20.nix
      ../development/compilers/zulu/20.nix
      {
        openjdk20-bootstrap = temurin-bin.jdk-20;
        openjfx = openjfx20;
      };

    openjdk21 = mkOpenjdk
      ../development/compilers/openjdk/21.nix
      ../development/compilers/zulu/21.nix
      {
        openjdk21-bootstrap = temurin-bin.jdk-21;
        openjfx = openjfx21;
      };

    temurin-bin = recurseIntoAttrs (callPackage (
      if stdenv.isLinux
      then ../development/compilers/temurin-bin/jdk-linux.nix
      else ../development/compilers/temurin-bin/jdk-darwin.nix
    ) {});

    semeru-bin = recurseIntoAttrs (callPackage (
      if stdenv.isLinux
      then ../development/compilers/semeru-bin/jdk-linux.nix
      else ../development/compilers/semeru-bin/jdk-darwin.nix
    ) {});
  };
}
// lib.optionalAttrs config.allowAliases {
  jogl_2_4_0 = throw "'jogl_2_4_0' is renamed to/replaced by 'jogl'";
  mavenfod = throw "'mavenfod' is renamed to/replaced by 'maven.buildMavenPackage'";
}
