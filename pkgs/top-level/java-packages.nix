{ pkgs }:
let
  inherit (pkgs)
    stdenv
    callPackage
    config
    lib
    ;
in
{
  inherit (pkgs) openjfx17 openjfx21 openjfx25;
  compiler = lib.recurseIntoAttrs (
    let
      # merge meta.platforms of both packages so that dependent packages and hydra build them
      mergeMetaPlatforms =
        jdk: other:
        jdk
        // {
          meta = jdk.meta // {
            platforms = lib.unique (jdk.meta.platforms ++ other.meta.platforms);
          };
        };

      mkLinuxDarwin =
        linux: darwin:
        if stdenv.hostPlatform.isLinux then
          mergeMetaPlatforms linux darwin
        else
          mergeMetaPlatforms darwin linux;

      mkOpenjdk =
        featureVersion:
        let
          openjdkLinux =
            (callPackage ../development/compilers/openjdk/generic.nix (
              {
                inherit featureVersion;
              }
              // lib.optionalAttrs (lib.versionOlder featureVersion "11") {
                enableGtk = false;
              }
            ))
            // {
              headless = mergeMetaPlatforms openjdkLinuxHeadless openjdkDarwin;
            };
          openjdkLinuxHeadless = openjdkLinux.override { headless = true; };
          openjdkDarwin = (callPackage (../development/compilers/zulu + "/${featureVersion}.nix") { }) // {
            headless = mergeMetaPlatforms openjdkDarwin openjdkLinuxHeadless;
          };
        in
        mkLinuxDarwin openjdkLinux openjdkDarwin;

      mkCorretto =
        majorVersion:
        callPackage ../development/compilers/corretto/mk-corretto.nix {
          inherit majorVersion;
        };
    in
    rec {
      corretto11 = mkCorretto "11";
      corretto17 = mkCorretto "17";
      corretto21 = mkCorretto "21";
      corretto25 = mkCorretto "25";

      openjdk8 = mkOpenjdk "8";
      openjdk11 = mkOpenjdk "11";
      openjdk17 = mkOpenjdk "17";
      openjdk21 = mkOpenjdk "21";
      openjdk25 = mkOpenjdk "25";

      # Legacy aliases
      openjdk8-bootstrap = temurin-bin.jdk-8;
      openjdk11-bootstrap = temurin-bin.jdk-11;
      openjdk17-bootstrap = temurin-bin.jdk-17;

      temurin-bin = lib.recurseIntoAttrs (
        let
          temurinLinux = import ../development/compilers/temurin-bin/jdk-linux.nix {
            inherit (pkgs) lib callPackage stdenv;
          };
          temurinDarwin = import ../development/compilers/temurin-bin/jdk-darwin.nix {
            inherit (pkgs) lib callPackage;
          };
        in
        lib.mapAttrs (name: drv: mkLinuxDarwin drv temurinDarwin.${name}) temurinLinux
      );

      semeru-bin = lib.recurseIntoAttrs (
        let
          semeruLinux = import ../development/compilers/semeru-bin/jdk-linux.nix {
            inherit (pkgs) lib callPackage;
          };
          semeruDarwin = import ../development/compilers/semeru-bin/jdk-darwin.nix {
            inherit (pkgs) lib callPackage;
          };
        in
        lib.mapAttrs (name: drv: mkLinuxDarwin drv semeruDarwin.${name}) semeruLinux
      );
    }
  );
}
// lib.optionalAttrs config.allowAliases {
  jogl_2_4_0 = throw "'jogl_2_4_0' is renamed to/replaced by 'jogl'";
  mavenfod = throw "'mavenfod' is renamed to/replaced by 'maven.buildMavenPackage'";
}
