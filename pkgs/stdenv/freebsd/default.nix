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
        url = "http://192.168.1.9:8000/npna7h5bbgzamk2vp3fqpdnpspq1hgin-x86_64-freebsd14-bootstrap-files.tar.xz";
        hash = "sha256-xgX5wVX6J+lSQiF12bxEggtvcTYAMIFPgeRtPzC0zKY=";
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
      inherit system;
      name = "bootstrap-tools";
      pname = "bootstrap-tools";
      version = "9.9.9";
      builder = all-bootstrap-files.bash;
      args = [ ./unpack-bootstrap-files.sh ];
      inherit (all-bootstrap-files) tar unxz mkdir chmod bootstrapFiles;
    });

    linkBS = (attrs: derivation (attrs // {
      inherit system;
      name = attrs.name or (builtins.baseNameOf (builtins.elemAt attrs.paths 0));
      src = bootstrap-tools;
      builder = all-bootstrap-files.bash;
      args = [./linkBS.sh];
      paths = attrs.paths;
      PATH = "${bootstrap-tools}/bin";
    }));

    bootstrapLibs = linkBS { name = "bootstrapLibs"; paths = ["lib" "include" "share" "libexec"]; pname = "libs"; version = "bootstrap"; };
    bsdcp = linkBS { paths = [ "bin/bsdcp" ]; };
    patchelf = linkBS { paths = [ "bin/patchelf" ]; };
    bash = linkBS { paths = ["bin/bash" "bin/sh"]; shell = "bin/bash"; };
    curl = linkBS { paths = ["bin/curl" "bin/curl-config" ]; };
    clang = linkBS { paths = [ "bin/clang" "bin/clang++" "bin/cpp" ]; version = "16"; };
    coreutils = linkBS { name = "coreutils"; paths = map (str: "bin/" + str) [
      "base64" "basename" "cat" "chcon"
      "chgrp" "chmod" "chown" "chroot" "cksum"
      "comm" "cp" "csplit" "cut" "date"
      "dd" "df" "dir" "dircolors" "dirname"
      "du" "echo" "env" "expand" "expr"
      "factor" "false" "fmt" "fold" "groups"
      "head" "hostid" "id" "install"
      "join" "kill" "link" "ln" "logname"
      "ls" "md5sum" "mkdir" "mkfifo" "mknod"
      "mktemp" "mv" "nice" "nl" "nohup"
      "nproc" "numfmt" "od" "paste" "pathchk"
      "pinky" "pr" "printenv" "printf" "ptx"
      "pwd" "readlink" "realpath" "rm" "rmdir"
      "runcon" "seq" "shred" "shuf" "sleep"
      "sort" "split" "stat" "stdbuf" "stty"
      "sum" "tac" "tail" "tee" "test"
      "timeout" "touch" "tr" "true" "truncate"
      "tsort" "tty" "uname" "unexpand" "uniq"
      "unlink" "users" "vdir" "wc"
      "who" "whoami" "yes"
    ]; };
    diffutils = linkBS { name = "diffutils"; paths = map (str: "bin/" + str) [
      "diff" "cmp" "diff3" "sdiff"
    ]; };
    findutils = linkBS { name = "findutils"; paths = [ "bin/find" "bin/xargs" ]; };
    iconv = linkBS { paths = [ "bin/iconv" ]; };
    patch = linkBS { paths = [ "bin/patch" ]; };
    gnutar = linkBS { paths = [ "bin/tar" ]; };
    gawk = linkBS { paths = [ "bin/awk" "bin/gawk" ]; };
    gnumake = linkBS { paths = [ "bin/make" ]; };
    gnugrep = linkBS { paths = [ "bin/grep" "bin/egrep" "bin/fgrep" ]; };
    gnused = linkBS { paths = [ "bin/sed" ]; };
    gzip = linkBS { paths = [ "bin/gzip" "bin/gunzip" ]; };
    bzip2 = linkBS { paths = [ "bin/bzip2" ]; };
    xz = linkBS { paths = [ "bin/xz" "bin/unxz" ]; };
    cacert = linkBS { paths = [ "etc/ssl/certs" "nix-support/setup-hook" ]; };
    binutils = linkBS { name = "binutils"; paths = map (str: "bin/" + str) [
      "ld" "as" "addr2line" "ar" "c++filt"
      "elfedit" "gprof" "objdump"
      "nm" "objcopy" "ranlib" "readelf" "size"
      "strings" "strip"
    ]; };


    fetchurl = import ../../build-support/fetchurl {
      inherit lib curl;
      stdenvNoCC = stdenvNoCC;
    };

    stdenvNoCC = import ../generic {
      inherit config;
      name = "freebsd-boot-0-stdenvNoCC";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      initialPath = [coreutils gnutar findutils gnumake gnused patchelf gnugrep gawk diffutils patch bash xz gzip bzip2 bsdcp];
      shell = "${bash}/bin/bash";
      fetchurlBoot = fetchurl;
      cc = null;
    };

    stdenv = import ../generic {
      inherit config;
      name = "freebsd-boot-0-stdenv";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      initialPath = [coreutils gnutar findutils gnumake gnused patchelf gnugrep gawk diffutils patch bash xz gzip bzip2 bsdcp];
      shell = "${bash}/bin/bash";
      fetchurlBoot = fetchurl;
      extraNativeBuildInputs = [./unpack-source.sh];
      cc = import ../../build-support/cc-wrapper ({
        inherit lib;
        name = "freebsd-boot-0-cc";
        nixSupport = {
          libcxx-ldflags = ["-lunwind"];
          libcxx-cxxflags = ["-isystem ${bootstrapLibs}/include/c++/v1"];
        };
        stdenvNoCC = stdenvNoCC;
        libc = bootstrapLibs;
        propagateDoc = false;
        nativeTools = false;
        nativeLibc = false;
        gnugrep = gnugrep;
        coreutils = coreutils;
        cc = clang;
        isClang = true;
        bintools = import ../../build-support/bintools-wrapper {
          inherit lib;
          stdenvNoCC = stdenvNoCC;
          name = "freebsd-boot-0-bintools";
          libc = bootstrapLibs;
          propagateDoc = false;
          nativeTools = false;
          nativeLibc = false;
          bintools = binutils;
          gnugrep = gnugrep;
          coreutils = coreutils;
        };
      });
      overrides = self: super: {
        inherit fetchurl curl cacert iconv;
        curlReal = super.curl;
      };
      preHook = ''
          export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
          export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
        '';
    };
  in { inherit config overlays stdenv; })

  (prevStage: let
    fetchurlBoot = import ../../build-support/fetchurl {
      inherit lib stdenvNoCC;
      curl = prevStage.curlReal;
    };

    bsdcp = (prevStage.runCommand "bsdcp" {} "mkdir -p $out/bin; cp ${prevStage.freebsd.cp}/bin/cp $out/bin/bsdcp");

    stdenvNoCC = import ../generic {
      inherit config fetchurlBoot;
      name = "stdenvNoCC-freebsd-boot-1";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      initialPath = [ prevStage.coreutils prevStage.gnutar prevStage.findutils prevStage.gnumake prevStage.gnused prevStage.patchelf prevStage.gnugrep prevStage.gawk prevStage.diffutils prevStage.patch prevStage.bash prevStage.gzip prevStage.bzip2 prevStage.xz bsdcp];
      shell = "${prevStage.bash}/bin/bash";
      cc = null;
    };

    in rec {
    inherit config overlays;
    stdenv = import ../generic {
      inherit config fetchurlBoot;
      name = "stdenv-freebsd-boot-1";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      initialPath = [ prevStage.coreutils prevStage.gnutar prevStage.findutils prevStage.gnumake prevStage.gnused prevStage.patchelf prevStage.gnugrep prevStage.gawk prevStage.diffutils prevStage.patch prevStage.bash prevStage.gzip prevStage.bzip2 prevStage.xz bsdcp];
      extraNativeBuildInputs = [./unpack-source.sh];
      shell = "${prevStage.bash}/bin/bash";
      cc = import ../../build-support/cc-wrapper ({
        inherit lib stdenvNoCC;
        name = "freebsd-boot-1-cc";
        nixSupport = {
          cc-ldflags = ["-L${lib.getLib prevStage.freebsd.libdl}/lib" "--push-state" "--as-needed" "-lgcc_s" "--pop-state"];
        };
        inherit (prevStage.freebsd) libc;
        inherit (prevStage) gnugrep coreutils;
        propagateDoc = false;
        nativeTools = false;
        nativeLibc = false;
        cc = prevStage.gcc-unwrapped;
        isGNU = true;
        bintools = import ../../build-support/bintools-wrapper {
          inherit lib stdenvNoCC;
          name = "freebsd-boot-1-bintools";
          inherit (prevStage.freebsd) libc;
          inherit (prevStage) gnugrep coreutils;
          bintools = prevStage.llvmPackages_16.bintools-unwrapped;
          propagateDoc = false;
          nativeTools = false;
          nativeLibc = false;
        };
      });
      overrides = self: super: {
        curl = prevStage.curlReal;
        bash = prevStage.bash;
        gitMinimal = prevStage.gitMinimal;
        freebsd = super.freebsd.overrideScope (self: super: {
          libdl = prevStage.freebsd.libdl;
        });
      };
      preHook = ''
          export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
          export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
        '';
    };
  })

  (prevStage: let
    fetchurlBoot = import ../../build-support/fetchurl {
      inherit lib stdenvNoCC;
      curl = prevStage.curl;
    };

    bsdcp = (prevStage.runCommand "bsdcp" {} "mkdir -p $out/bin; cp ${prevStage.freebsd.cp}/bin/cp $out/bin/bsdcp");

    stdenvNoCC = import ../generic {
      inherit config fetchurlBoot;
      name = "stdenvNoCC-freebsd";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      initialPath = [ prevStage.coreutils prevStage.gnutar prevStage.findutils prevStage.gnumake prevStage.gnused prevStage.patchelf prevStage.gnugrep prevStage.gawk prevStage.diffutils prevStage.patch prevStage.bash prevStage.gzip prevStage.bzip2 prevStage.xz bsdcp];
      shell = "${prevStage.bash}/bin/bash";
      cc = null;
    };

    in rec {
    inherit config overlays;
    stdenv = import ../generic {
      inherit config fetchurlBoot;
      name = "stdenv-freebsd";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      initialPath = [ prevStage.coreutils prevStage.gnutar prevStage.findutils prevStage.gnumake prevStage.gnused prevStage.patchelf prevStage.gnugrep prevStage.gawk prevStage.diffutils prevStage.patch prevStage.bash prevStage.gzip prevStage.bzip2 prevStage.xz bsdcp];
      extraNativeBuildInputs = [./unpack-source.sh];
      shell = "${prevStage.bash}/bin/bash";
      cc = import ../../build-support/cc-wrapper ({
        inherit lib stdenvNoCC;
        name = "freebsd-cc";
        nixSupport = {
          cc-ldflags = ["-L${lib.getLib prevStage.freebsd.libdl}/lib" "--push-state" "--as-needed" "-lgcc_s" "--pop-state"];
        };
        inherit (prevStage.freebsd) libc;
        inherit (prevStage) gnugrep coreutils;
        propagateDoc = false;
        nativeTools = false;
        nativeLibc = false;
        cc = prevStage.gcc-unwrapped;
        isGNU = true;
        bintools = import ../../build-support/bintools-wrapper {
          inherit lib stdenvNoCC;
          name = "freebsd-bintools";
          inherit (prevStage.freebsd) libc;
          inherit (prevStage) gnugrep coreutils;
          bintools = prevStage.llvmPackages_16.bintools-unwrapped;
          propagateDoc = false;
          nativeTools = false;
          nativeLibc = false;
        };
      });
      overrides = self: super: {
        #curl = prevStage.curl;
        #bash = prevStage.bash;
        inherit (prevStage) fetchurl;
      };
      preHook = ''
          export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
          export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
        '';
    };
  })
]
