{ pkgs }:

with pkgs;

{
  inherit (pkgs) openjfx17 openjfx21 openjfx23;

  compiler =
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
            (callPackage ../development/compilers/openjdk/generic.nix { inherit featureVersion; })
            // {
              headless = mergeMetaPlatforms openjdkLinuxHeadless openjdkDarwin;
            };
          openjdkLinuxHeadless = openjdkLinux.override { headless = true; };
          openjdkDarwin = (callPackage (../development/compilers/zulu + "/${featureVersion}.nix") { }) // {
            headless = mergeMetaPlatforms openjdkDarwin openjdkLinuxHeadless;
          };
        in
        mkLinuxDarwin openjdkLinux openjdkDarwin;
    in
    rec {
      corretto11 = callPackage ../development/compilers/corretto/11.nix { };
      corretto17 = callPackage ../development/compilers/corretto/17.nix { };
      corretto21 = callPackage ../development/compilers/corretto/21.nix { };

      openjdk8 = mkOpenjdk "8";
      openjdk11 = mkOpenjdk "11";
      openjdk17 = mkOpenjdk "17";
      openjdk21 = mkOpenjdk "21";
      openjdk23 = mkOpenjdk "23";
      openjdk24 = mkOpenjdk "24";
      openjdk25 = mkOpenjdk "25";

      # Legacy aliases
      openjdk8-bootstrap = temurin-bin.jdk-8;
      openjdk11-bootstrap = temurin-bin.jdk-11;
      openjdk17-bootstrap = temurin-bin.jdk-17;

      temurin-bin = recurseIntoAttrs (
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

      semeru-bin = recurseIntoAttrs (
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
    };
}
// lib.optionalAttrs config.allowAliases {
  jogl_2_4_0 = throw "'jogl_2_4_0' is renamed to/replaced by 'jogl'";
  mavenfod = throw "'mavenfod' is renamed to/replaced by 'maven.buildMavenPackage'";
}
