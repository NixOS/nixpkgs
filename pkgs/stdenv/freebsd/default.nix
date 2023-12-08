{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
}:

assert crossSystem == localSystem;
let inherit (localSystem) system;
  all-bootstrap-urls-table = {
    x86_64-freebsd14 = {
      bash = {
        url = "http://192.168.1.9:8000/caddwlc57s8z6qmdimg0xiwmgkkl7r9f-x86_64-freebsd14-bash";
        hash = "sha256-l0wIsbULNDR6yxGromq85Ulb4i5KH9g+2Fh1ZH4Obz4=";
      };
      mkdir = {
        url = "http://192.168.1.9:8000/n8f9n9bi3bvjsvaf6936dasir87r15x0-x86_64-freebsd14-mkdir";
        hash = "sha256-Wje9u9mz5kiTNSoPvmvgGwxQRgLnBM+26jPadbUTkpg=";
      };
      tar = {
        url = "http://192.168.1.9:8000/s0b2xj587gakdiw2kph3kgpwwc0p3wl7-x86_64-freebsd14-tar";
        hash = "sha256-jMb9QnDPCVjyDErTLrhZW9E2KsoS95gIWPvZum5Sy8E=";
      };
      unxz = {
        url = "http://192.168.1.9:8000/80v8cjpy1b8wgliza5ynwygrgn64a452-x86_64-freebsd14-unxz";
        hash = "sha256-yVPhB2tOwGP5aieKTJw+bXdNaM2ye8foo9SJkU3bgEY=";
      };
      chmod = {
        url = "http://192.168.1.9:8000/5f5kypi47g1bgm1w77akq9nmrm9wbw8j-x86_64-freebsd14-chmod";
        hash = "sha256-01dHQyHH4xnnMTgKgYFN2ksgXhhnub6fBrgUFSYjRJ0=";
      };
      bootstrapFiles = {
        url = "http://192.168.1.9:8000/g4vqf2876zwwhkbny3qm59vc00679bk3-x86_64-freebsd14-bootstrap-files.tar.xz";
        hash = "sha256-S3ch3LEVNqmQoXFzoQbzAqvULhZ90YwWcE6S5AaAHBc=";
      };
    };
  };
  fetchurlBoot = import <nix/fetchurl.nix>;
  all-bootstrap-urls = all-bootstrap-urls-table.${localSystem.system};
  all-bootstrap-files = lib.mapAttrs (a: v: fetchurlBoot (v // { executable = a != "bootstrapFiles"; })) all-bootstrap-urls;
in
[
  ({}: let
    bootstrap-tools = (derivation {
      name = "bootstrap-tools";
      pname = "bootstrap-tools";
      builder = all-bootstrap-files.bash;
      args = [ ./unpack-bootstrap-files.sh ];
      inherit (all-bootstrap-files) tar unxz mkdir chmod bootstrapFiles;
      inherit system;
      shellPath = "bin/bash";

      version = "16";  # clang version
    });

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
      fetchurlBoot = fetchurl;
      extraNativeBuildInputs = [./unpack-source.sh];
      cc = import ../../build-support/cc-wrapper ({
        inherit lib;
        name = "bootstrap-tools-cc-wrapper";
        nixSupport = {
          libcxx-ldflags = ["-stdlib=libc++" "-unwind=libunwind" "-lunwind"];
          libcxx-cxxflags = ["-isystem ${bootstrap-tools}/include/c++/v1"];
        };
        stdenvNoCC = stdenvNoCC;
        libc = bootstrap-tools;
        propagateDoc = false;
        nativeTools = false;
        nativeLibc = false;
        gnugrep = bootstrap-tools;
        coreutils = bootstrap-tools;
        cc = bootstrap-tools;
        #libcxx = bootstrap-tools;
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
        #bash = bootstrap-tools;
        freebsd = super.freebsd.overrideScope (self': super': {
          boot-install = bootstrap-tools;
          install = bootstrap-tools;
        });
        curl = bootstrap-tools;
      };
      preHook = ''
          export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
          export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
        '';
    };
  in { inherit config overlays stdenv; })

  #(prevStage: rec {
  #  inherit config overlays;
  #  stdenv = import ../generic {
  #    inherit config;
  #    name = "stdenv-freebsd-boot-1";
  #    buildPlatform = localSystem;
  #    hostPlatform = localSystem;
  #    targetPlatform = localSystem;
  #    initialPath = [ prevStage.coreutils prevStage.findutils prevStage.bootstrap-tools];
  #    shell = "${prevStage.bootstrap-tools}/bin/bash";
  #    fetchurlBoot = prevStage.fetchurl;
  #    extraNativeBuildInputs = [./unpack-source.sh];
  #    cc = prevStage.stdenv.cc;
  #    overrides = self: super: {
  #      fetchurl = prevStage.fetchurl;
  #      freebsd = super.freebsd.overrideScope (self': super': {
  #        boot-install = prevStage.coreutils;
  #      });
  #      curl = prevStage.bootstrap-tools;
  #    };
  #    preHook = ''
  #        export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
  #        export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
  #      '';
  #  };
  #})

  #(prevStage: rec {
  #  inherit config overlays;
  #  stdenv = import ../generic {
  #    inherit config;
  #    name = "stdenv-freebsd-boot-2";
  #    buildPlatform = localSystem;
  #    hostPlatform = localSystem;
  #    targetPlatform = localSystem;
  #    initialPath = [ prevStage.coreutils prevStage.gnutar prevStage.findutils prevStage.gnumake prevStage.gnused prevStage.patchelf prevStage.gnugrep prevStage.gawk prevStage.diffutils prevStage.patch prevStage.bash prevStage.gzip prevStage.bzip2 prevStage.xz prevStage.freebsd.cp];
  #    shell = prevStage.bash;
  #    fetchurlBoot = prevStage.fetchurl;
  #    cc = import ../../build-support/cc-wrapper ({
  #      inherit lib;
  #      name = "stdenv-freebsd-boot-1-cc";
  #      stdenvNoCC = prevStage.stdenv;
  #      inherit (prevStage.freebsd) libc;
  #      inherit (prevStage) gnugrep coreutils;
  #      propagateDoc = false;
  #      nativeTools = false;
  #      nativeLibc = false;
  #      cc = prevStage.gcc-unwrapped;
  #      bintools = import ../../build-support/bintools-wrapper {
  #        inherit lib;
  #        stdenvNoCC = prevStage.stdenv;
  #        name = "bootstrap-tools-bintools-wrapper";
  #        inherit (prevStage.freebsd) libc;
  #        inherit (prevStage) gnugrep coreutils;
  #        bintools = prevStage.bintools-unwrapped;
  #        propagateDoc = false;
  #        nativeTools = false;
  #        nativeLibc = false;
  #      };
  #    });
  #    overrides = self: super: {
  #      fetchurl = prevStage.fetchurl;
  #      freebsd = super.freebsd.overrideScope (self': super': {
  #        boot-install = prevStage.coreutils;
  #        #curl = bootstrap-tools;
  #      });
  #    };
  #    preHook = ''
  #        export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
  #        export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
  #      '';
  #  };
  #})
]
