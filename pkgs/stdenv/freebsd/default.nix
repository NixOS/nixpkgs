{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
}:

assert crossSystem == localSystem;
let inherit (localSystem) system;
  all-bootstrap-urls-table = {
    x86_64-freebsd14 = {
      bash = {
        url = "http://192.168.1.9:8000/7xqibz202wnpcq20l9hzkpd6blb8rn0m-x86_64-freebsd14-bash";
        hash = "sha256-7f+JfrtJGy3SVyppr9T7SaH4WkjFFjonFwPZkx34/mU=";
      };
      mkdir = {
        url = "http://192.168.1.9:8000/ajb03wdfzmrr29620v37ixgmmbsazqbk-x86_64-freebsd14-mkdir";
        hash = "sha256-Wje9u9mz5kiTNSoPvmvgGwxQRgLnBM+26jPadbUTkpg=";
      };
      tar = {
        url = "http://192.168.1.9:8000/mx3d5y48y1xvr7q0hs7f78sxr0rrcpsg-x86_64-freebsd14-tar";
        hash = "sha256-FtPeqH/IHNmBT9rEzHv9EDOah6VivW9wd7O5x2fMpdE=";
      };
      unxz = {
        url = "http://192.168.1.9:8000/0g3qxarqw5fxk149ly3ig57xwl1avy5j-x86_64-freebsd14-unxz";
        hash = "sha256-yVPhB2tOwGP5aieKTJw+bXdNaM2ye8foo9SJkU3bgEY=";
      };
      chmod = {
        url = "http://192.168.1.9:8000/gj7mlcl06zf7ryy880cjifm30hq5yjx1-x86_64-freebsd14-chmod";
        hash = "sha256-01dHQyHH4xnnMTgKgYFN2ksgXhhnub6fBrgUFSYjRJ0=";
      };
      bootstrapFiles = {
        url = "http://192.168.1.9:8000/sp8hl7xmzscm9498npa41czq97q2ghyg-x86_64-freebsd14-bootstrap-files.tar.xz";
        hash = "sha256-39yv6WfQv0Nno4O72jXmYFaGgTa8xxQcB1j3GIrCQvM=";
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
          #curl = bootstrap-tools;
        });
      };
      preHook = ''
          export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
          export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
        '';
    };
  in { inherit config overlays stdenv; })

  (prevStage: rec {
    inherit config overlays;
    stdenv = import ../generic {
      inherit config;
      name = "stdenv-freebsd-boot-1";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      initialPath = [ prevStage.coreutils prevStage.gnutar prevStage.findutils prevStage.gnumake prevStage.gnused prevStage.patchelf prevStage.gnugrep prevStage.gawk prevStage.diffutils prevStage.patch prevStage.bash prevStage.gzip prevStage.bzip2 prevStage.xz prevStage.freebsd.cp];
      shell = prevStage.bash;
      fetchurlBoot = prevStage.fetchurl;
      cc = import ../../build-support/cc-wrapper ({
        inherit lib;
        name = "stdenv-freebsd-boot-1-cc";
        stdenvNoCC = prevStage.stdenv;
        inherit (prevStage.freebsd) libc;
        inherit (prevStage) gnugrep coreutils;
        propagateDoc = false;
        nativeTools = false;
        nativeLibc = false;
        cc = prevStage.gcc-unwrapped;
        bintools = import ../../build-support/bintools-wrapper {
          inherit lib;
          stdenvNoCC = prevStage.stdenv;
          name = "bootstrap-tools-bintools-wrapper";
          inherit (prevStage.freebsd) libc;
          inherit (prevStage) gnugrep coreutils;
          bintools = prevStage.bintools-unwrapped;
          propagateDoc = false;
          nativeTools = false;
          nativeLibc = false;
        };
      });
      overrides = self: super: {
        fetchurl = prevStage.fetchurl;
        freebsd = super.freebsd.overrideScope (self': super': {
          boot-install = prevStage.coreutils;
          #curl = bootstrap-tools;
        });
      };
      preHook = ''
          export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
          export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
        '';
    };
  })
]
