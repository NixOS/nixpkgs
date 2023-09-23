{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
}:

assert crossSystem == localSystem;
let inherit (localSystem) system;
  trivialBuilder = (import ./trivial-builder.nix);
  all-bootstrap-urls-table = {
    x86_64-freebsd14 = {
      bash = {
        url = "http://192.168.1.9:8000/v04k0p2b5ps86w56h70myaw4wcpf1a5b-x86_64-freebsd14-bash";
        hash = "sha256-F0c3LT1XBl5g2eKsaj3Y8tXT0NnaKUb+qOV5y9U4Fis=";
      };
      mkdir = {
        url = "http://192.168.1.9:8000/2r8n72xjqcx91jvzilw9yimbkvbcalbp-x86_64-freebsd14-mkdir";
        hash = "sha256-Wje9u9mz5kiTNSoPvmvgGwxQRgLnBM+26jPadbUTkpg=";
      };
      tar = {
        url = "http://192.168.1.9:8000/wb5q48dipl4p8f83rbgggcxab4n02r90-x86_64-freebsd14-tar";
        hash = "sha256-NClJCZiW7p4rDllguiWthftS9TjwTWh5ZSe+7CMCSzs=";
      };
      unxz = {
        url = "http://192.168.1.9:8000/gmqhzn12jd575xxxd59ic8g46m749g7j-x86_64-freebsd14-unxz";
        hash = "sha256-yVPhB2tOwGP5aieKTJw+bXdNaM2ye8foo9SJkU3bgEY=";
      };
      bootstrapFiles = {
        url = "http://192.168.1.9:8000/gkzdw7a5pb3xj1py6w0r7xfna597ksqy-x86_64-freebsd14-bootstrap-files.tar.gz";
        hash = "sha256-SMFdhT6dKFmEcVw/p44u5T8FxVvvM43v7J7nZ7DAhMM=";
      };
    };
  };
  fetchurlBoot = import ../../build-support/fetchurl/boot.nix {
    inherit system;
  };
  all-bootstrap-urls = all-bootstrap-urls-table.${localSystem.system};
  all-bootstrap-files = lib.mapAttrs (_: v: fetchurlBoot v) all-bootstrap-urls;
in
[
  ({}: let
    bootstrap-tools = derivation {
      name = "bootstrap-tools";
      builder = all-bootstrap-files.bash;
      args = [ ./unpack-bootstrap-files.sh ];
      inherit (all-bootstrap-files) tar unxz mkdir bootstrapFiles;
    };

    fetchurl = import ../../build-support/fetchurl {
      inherit lib;
      stdenvNoCC = stdenv;
      curl = bootstrap-tools;
    };
    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-0";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      inherit config;
      shell = "${bootstrap-tools}/bin/bash";
      fetchurlBoot = fetchurl;
      cc = import ../../build-support/cc-wrapper ({
        inherit lib;
        name = "bootstrap-tools-cc-wrapper";
        stdenvNoCC = stdenv;
        libc = bootstrap-tools;
        propagateDoc = false;
        nativeTools = false;
        nativeLibc = false;
        gnugrep = bootstrap-tools;
        coreutils = bootstrap-tools;
        isClang = true;
        bintools = import ../../build-support/bintools-wrapper {
          inherit lib;
          stdenvNoCC = stdenv;
          name = "bootstrap-tools-bintools-wrapper";
          libc = bootstrap-tools;
          propagateDoc = false;
          nativeTools = false;
          nativeLibc = false;
          bintools = bootstrap-tools;
          gnugrep = bootstrap-tools;
          coreutils = bootstrap-tools;
        };
      });
      overrides = self: super: {
        inherit bootstrap-tools fetchurl;
      };
    };
  in { inherit config overlays stdenv; })
]
