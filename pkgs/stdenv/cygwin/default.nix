{
  lib,
  localSystem,
  crossSystem,
  config,
  overlays,
  crossOverlays ? [ ],
  bootstrapFiles ?
    let
      table = {
        x86_64-cygwin = {
          # import ./bootstrap-files/x86_64-pc-cygwin.nix;
          unpack = import <nix/fetchurl.nix> {
            url = "https://github.com/corngood/nixpkgs/releases/download/bootstrap%2Fv0.1/unpack.nar.xz";
            hash = "sha256-B5pezEcJkWtI0nDRCeOjtwSQ4OTuA2ef06keEvr4i4E=";
            name = "unpack";
            unpack = true;
          };
        };
      };
      files =
        table.${localSystem.system}
          or (throw "unsupported platform ${localSystem.system} for the cygwin stdenv");
    in
    files,
}:

assert crossSystem == localSystem;
let
  linkBootstrap = (
    attrs:
    derivation (
      attrs
      // {
        inherit (localSystem) system;
        name = attrs.name or (baseNameOf (builtins.elemAt attrs.paths 0));
        version = "bootstrap";
        src = bootstrapFiles.unpack;
        builder = "${bootstrapFiles.unpack}/bin/bash";
        args = [
          ./linkBootstrap.sh
        ];
        PATH = "${bootstrapFiles.unpack}/bin";
        cygwinDllLink = ../../build-support/setup-hooks/cygwin-dll-link.sh;
        paths = attrs.paths;
      }
    )
  );

  bootstrap-packages = {
    bashNonInteractive = linkBootstrap {
      paths = [
        "bin/bash"
        "bin/sh"
      ];
      shell = "bin/bash";
      shellPath = "/bin/bash";
    };
    binutils-unwrapped = linkBootstrap {
      name = "binutils";
      paths = map (str: "bin/" + str) [
        "ld"
        "as"
        "addr2line"
        "ar"
        "c++filt"
        "dlltool"
        "elfedit"
        "gprof"
        "objdump"
        "nm"
        "objcopy"
        "ranlib"
        "readelf"
        "size"
        "strings"
        "strip"
        "windres"
      ];
    };
    bzip2.bin = linkBootstrap { paths = [ "bin/bzip2" ]; };
    coreutils = linkBootstrap {
      name = "coreutils";
      paths = map (str: "bin/" + str) [
        "base64"
        "basename"
        "cat"
        "chcon"
        "chgrp"
        "chmod"
        "chown"
        "chroot"
        "cksum"
        "comm"
        "cp"
        "csplit"
        "cut"
        "date"
        "dd"
        "df"
        "dir"
        "dircolors"
        "dirname"
        "du"
        "echo"
        "env"
        "expand"
        "expr"
        "factor"
        "false"
        "fmt"
        "fold"
        "groups"
        "head"
        "hostid"
        "id"
        "install"
        "join"
        "kill"
        "link"
        "ln"
        "logname"
        "ls"
        "md5sum"
        "mkdir"
        "mkfifo"
        "mknod"
        "mktemp"
        "mv"
        "nice"
        "nl"
        "nohup"
        "nproc"
        "numfmt"
        "od"
        "paste"
        "pathchk"
        "pinky"
        "pr"
        "printenv"
        "printf"
        "ptx"
        "pwd"
        "readlink"
        "realpath"
        "rm"
        "rmdir"
        "runcon"
        "seq"
        "shred"
        "shuf"
        "sleep"
        "sort"
        "split"
        "stat"
        "stty"
        "sum"
        "tac"
        "tail"
        "tee"
        "test"
        "timeout"
        "touch"
        "tr"
        "true"
        "truncate"
        "tsort"
        "tty"
        "uname"
        "unexpand"
        "uniq"
        "unlink"
        "users"
        "vdir"
        "wc"
        "who"
        "whoami"
        "yes"
        "["
      ];
    };
    curl = linkBootstrap {
      paths = [
        "bin/curl"
      ];
    };
    diffutils = linkBootstrap {
      name = "diffutils";
      paths = map (str: "bin/" + str) [
        "diff"
        "cmp"
        #"diff3"
        #"sdiff"
      ];
    };
    # expand-response-params = bootstrapFiles.unpack;
    file = linkBootstrap {
      name = "file";
      paths = [ "bin/file" ];
    };
    findutils = linkBootstrap {
      name = "findutils";
      paths = [
        "bin/find"
        "bin/xargs"
      ];
    };
    gawk = linkBootstrap {
      paths = [
        "bin/awk"
        "bin/gawk"
      ];
    };
    gcc-unwrapped = linkBootstrap {
      name = "gcc";
      paths = map (str: "bin/" + str) [
        "gcc"
        "g++"
        "cygatomic-1.dll"
        "cyggcc_s-seh-1.dll"
        "cygquadmath-0.dll"
        "cygstdc++-6.dll"
      ];
    };
    git = linkBootstrap { paths = [ "bin/git" ]; };
    gnugrep = linkBootstrap {
      paths = [
        "bin/grep"
        "bin/egrep"
        "bin/fgrep"
      ];
    };
    gnumake = linkBootstrap { paths = [ "bin/make" ]; };
    gnused = linkBootstrap { paths = [ "bin/sed" ]; };
    gnutar = linkBootstrap { paths = [ "bin/tar" ]; };
    gzip = linkBootstrap {
      paths = [
        "bin/gzip"
        #"bin/gunzip"
      ];
      postBuild = ''
        rm "$out"/bin/gzip
        sed -E 's:/nix/store/[^/]*:'$src':' "$src"/bin/gzip > "$out"/bin/gzip
        chmod +x "$out"/bin/gzip
      '';
    };
    libc = linkBootstrap {
      name = "libc";
      paths = [
        "include"
        "lib"
      ];
    };
    patch = linkBootstrap { paths = [ "bin/patch" ]; };
    xz.bin = linkBootstrap { paths = [ "bin/xz" ]; };
  };

in
[
  (
    prevStage:
    let
      initialPath =
        # TODO: switch to this
        # ((import ../generic/common-path.nix) { pkgs = bootstrap-packages; })
        with bootstrap-packages;
        [
          coreutils
          diffutils
          gnutar
          file
          findutils
          gnumake
          gnused
          gnugrep
          gawk
          patch
          bashNonInteractive
          gzip
          bzip2.bin
          xz.bin
        ]
        # needed for cygwin1.dll
        # TODO: remove?
        ++ [ "/" ];

      shell = "${bootstrap-packages.bashNonInteractive}/bin/bash";

      stdenvNoCC = import ../generic rec {
        name = "stdenv-cygwin-boot0";

        buildPlatform = localSystem;
        hostPlatform = localSystem;
        targetPlatform = localSystem;
        inherit
          config
          initialPath
          fetchurlBoot
          shell
          ;

        hasCC = false;
        cc = null;

        preHook = ''
          OBJDUMP=objdump
        '';
        extraNativeBuildInputs = [ bootstrap-packages.binutils-unwrapped ];

        overrides = self: super: {
          fetchurl = lib.makeOverridable fetchurlBoot;
          fetchgit = super.fetchgit.override {
            inherit (bootstrap-packages) git;
            cacert = null;
            git-lfs = null;
          };
        };
      };

      fetchurlBoot = import ../../build-support/fetchurl {
        inherit lib stdenvNoCC;
        inherit (bootstrap-packages) curl;
        inherit (config) rewriteURL hashedMirrors;
      };

    in
    {
      inherit config overlays stdenvNoCC;
      stdenv = stdenvNoCC;
    }
  )

  (prevStage: {
    inherit config overlays;
    inherit (prevStage) stdenvNoCC;

    stdenv = import ../generic rec {
      name = "stdenv-cygwin-boot1";

      inherit config;
      inherit (prevStage.stdenv)
        buildPlatform
        hostPlatform
        targetPlatform
        fetchurlBoot
        initialPath
        shell
        ;

      extraNativeBuildInputs = [ cc.bintools ];

      cc = lib.makeOverridable (import ../../build-support/cc-wrapper) {
        inherit lib;
        inherit (prevStage) stdenvNoCC;
        name = "${name}-cc";
        cc = bootstrap-packages.gcc-unwrapped;
        isGNU = true;
        libc = prevStage.cygwin.newlib-cygwin-headers;
        inherit (bootstrap-packages) gnugrep coreutils;
        expand-response-params = "";
        nativeTools = false;
        nativeLibc = false;
        propagateDoc = false;
        runtimeShell = shell;
        bintools = lib.makeOverridable (import ../../build-support/bintools-wrapper) {
          inherit lib;
          inherit (prevStage) stdenvNoCC;
          name = "${name}-bintools";
          bintools = bootstrap-packages.binutils-unwrapped;
          libc = prevStage.cygwin.newlib-cygwin-headers;
          inherit (bootstrap-packages) gnugrep coreutils;
          expand-response-params = "";
          nativeTools = false;
          nativeLibc = false;
          propagateDoc = false;
          runtimeShell = shell;
        };
      };

      overrides = self: super: {
        fetchurl = lib.makeOverridable fetchurlBoot;
        fetchgit = super.fetchgit.override {
          inherit (bootstrap-packages) git;
          cacert = null;
          git-lfs = null;
        };
      };
    };
  })

  (prevStage: {
    inherit config overlays;

    stdenv = import ../generic rec {
      name = "stdenv-cygwin-boot2";

      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      inherit config;
      inherit (prevStage.stdenv) fetchurlBoot initialPath shell;

      extraNativeBuildInputs = [ cc.bintools ];

      cc = lib.makeOverridable (import ../../build-support/cc-wrapper) {
        inherit lib;
        inherit (prevStage) stdenvNoCC;
        name = "${name}-cc";
        cc = bootstrap-packages.gcc-unwrapped;
        isGNU = true;
        libc = bootstrap-packages.libc // {
          inherit (prevStage.cygwin) w32api;
        };
        inherit (bootstrap-packages) gnugrep coreutils;
        expand-response-params = "";
        nativeTools = false;
        nativeLibc = false;
        propagateDoc = false;
        runtimeShell = shell;
        bintools = lib.makeOverridable (import ../../build-support/bintools-wrapper) {
          inherit lib;
          inherit (prevStage) stdenvNoCC;
          name = "${name}-bintools";
          bintools = bootstrap-packages.binutils-unwrapped;
          libc = bootstrap-packages.libc // {
            inherit (prevStage.cygwin) w32api;
          };
          inherit (bootstrap-packages) gnugrep coreutils;
          expand-response-params = "";
          nativeTools = false;
          nativeLibc = false;
          propagateDoc = false;
          runtimeShell = shell;
        };
      };

      overrides = self: super: {
        fetchurl = lib.makeOverridable fetchurlBoot;
        __realFetchUrl = super.fetchurl;
        fetchgit = super.fetchgit.override {
          inherit (bootstrap-packages) git;
          cacert = null;
          git-lfs = null;
        };
      };
    };
  })

  (prevStage: {
    inherit config overlays;

    stdenv = import ../generic rec {
      name = "stdenv-cygwin-boot3";

      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      inherit config;

      initialPath = ((import ../generic/common-path.nix) { pkgs = prevStage; });

      extraNativeBuildInputs = [ cc.bintools ];

      cc = prevStage.gcc;

      shell = cc.shell;

      inherit (prevStage.stdenv) fetchurlBoot;

      overrides = self: super: {
        inherit (prevStage) fetchurl;
        __realFetchUrl = super.fetchurl;
      };
    };
  })

  (prevStage: {
    inherit config overlays;

    stdenv = import ../generic rec {
      name = "stdenv-cygwin";

      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      inherit config;

      initialPath = ((import ../generic/common-path.nix) { pkgs = prevStage; });

      extraNativeBuildInputs = [ cc.bintools ];

      cc = prevStage.gcc.override (old: {
        cc = old.cc.overrideAttrs (old: {
          # break dependency on previous stage cygintl-8.dll
          preFixup = old.preFixup or "" + ''
            ln -s "${lib.getLib prevStage.gettext}"/bin/cygintl-8.dll "$out"/bin
          '';
        });
      });

      shell = cc.shell;

      inherit (prevStage.stdenv) fetchurlBoot;

      disallowedRequisites = [ bootstrapFiles.unpack ];

      overrides = self: super: {
        fetchurl = prevStage.__realFetchUrl;
      };
    };
  })
]
