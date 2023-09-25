{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
}:

assert crossSystem == localSystem;
let inherit (localSystem) system;
  trivialBuilder = (import ./trivial-builder.nix);
  all-bootstrap-urls-table = {
    x86_64-freebsd14 = {
      bash = {
        url = "http://192.168.1.9:8000/m5kfzz6pz4w8mll56pv3ksr0jxgi66fs-x86_64-freebsd14-bash";
        hash = "sha256-1Ke4602F+pe5mUd4c8q1nSCEBHuo2JSZlBs8dZj6vn8=";
      };
      mkdir = {
        url = "http://192.168.1.9:8000/02zndx9ymf0i74nrww5rhanpy04p7fvk-x86_64-freebsd14-mkdir";
        hash = "sha256-Wje9u9mz5kiTNSoPvmvgGwxQRgLnBM+26jPadbUTkpg=";
      };
      tar = {
        url = "http://192.168.1.9:8000/732g8sama6bgfws06w96h47cc3fch51w-x86_64-freebsd14-tar";
        hash = "sha256-uZIGRfpPMPFcI1XzDf2brWHKd8gEe1ZP9mhTYjrDo/4=";
      };
      unxz = {
        url = "http://192.168.1.9:8000/2ypky4yn38jrwmbb1bcrrknyihgbcda9-x86_64-freebsd14-unxz";
        hash = "sha256-yVPhB2tOwGP5aieKTJw+bXdNaM2ye8foo9SJkU3bgEY=";
      };
      chmod = {
        url = "http://192.168.1.9:8000/74sc194l4iiiq3798mqnvnmyi2qsc2nm-x86_64-freebsd14-chmod";
        hash = "sha256-01dHQyHH4xnnMTgKgYFN2ksgXhhnub6fBrgUFSYjRJ0=";
      };
      bootstrapFiles = {
        url = "http://192.168.1.9:8000/m5r8mmfv6gh8622jxyyk3rgxvdi900gw-x86_64-freebsd14-bootstrap-files.tar.xz";
        hash = "sha256-KVB1+jwr+cSq9DyBTE0XkMCRgtPy5PMnJpKGqX2Hp9E=";
      };
    };
  };
  fetchurlBoot = import <nix/fetchurl.nix>;
  all-bootstrap-urls = all-bootstrap-urls-table.${localSystem.system};
  all-bootstrap-files = lib.mapAttrs (a: v: fetchurlBoot (v // { executable = a != "bootstrapFiles"; })) all-bootstrap-urls;
in
[
  ({}: let
    bootstrap-tools = derivation {
      name = "bootstrap-tools";
      builder = all-bootstrap-files.bash;
      args = [ ./unpack-bootstrap-files.sh ];
      inherit (all-bootstrap-files) tar unxz mkdir chmod bootstrapFiles;
      inherit system;
    };

    fetchurl = import ../../build-support/fetchurl {
      inherit lib;
      stdenvNoCC = stdenvNoCC;
      curl = bootstrap-tools;
    };

    stdenvNoCC = import ../generic {
      inherit config;
      name = "stdenvNoCC-freebsd-boot-0";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      initialPath = [ bootstrap-tools ];
      shell = "${bootstrap-tools}/bin/bash";
      #shell = "/usr/local/bin/bash";
      fetchurlBoot = fetchurl;
      cc = null;
    };

    stdenv = import ../generic {
      inherit config;
      name = "stdenv-freebsd-boot-0";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      initialPath = [bootstrap-tools];
      shell = "${bootstrap-tools}/bin/bash";
      #shell = "/usr/local/bin/bash";
      fetchurlBoot = fetchurl;
      cc = import ../../build-support/cc-wrapper ({
        inherit lib;
        name = "bootstrap-tools-cc-wrapper";
        stdenvNoCC = stdenvNoCC;
        libc = bootstrap-tools;
        propagateDoc = false;
        nativeTools = false;
        nativeLibc = false;
        gnugrep = bootstrap-tools;
        coreutils = bootstrap-tools;
        cc = bootstrap-tools;
        isClang = true;
        bintools = import ../../build-support/bintools-wrapper {
          inherit lib;
          stdenvNoCC = stdenvNoCC;
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
        bash = bootstrap-tools;
      };
      preHook = ''
          export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
          export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
        '';
    };
  in { inherit config overlays stdenv; })
]
