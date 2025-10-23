# afaik the longest dependency chain is stdenv -> stdenv-1#coreutils -> stdenv-1#gmp -> stdenv-0#libcxx -> stdenv-0#libc
# this is only possible through aggressive hacking to make libcxx build with stdenv-0#libc instead of bootstrapTools.libc.
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
        x86_64-freebsd = import ./bootstrap-files/x86_64-unknown-freebsd.nix;
      };
      files =
        table.${localSystem.system}
          or (throw "unsupported platform ${localSystem.system} for the pure FreeBSD stdenv");
    in
    files,
}:

assert crossSystem == localSystem;
let
  inherit (localSystem) system;
  mkExtraBuildCommands0 = cc: ''
    rsrc="$out/resource-root"
    mkdir "$rsrc"
    ln -s "${lib.getLib cc}/lib/clang/${lib.versions.major cc.version}/include" "$rsrc"
    echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
  '';
  mkExtraBuildCommands =
    cc: compiler-rt:
    mkExtraBuildCommands0 cc
    + ''
      ln -s "${compiler-rt.out}/lib" "$rsrc/lib"
      ln -s "${compiler-rt.out}/share" "$rsrc/share"
    '';

  bootstrapArchive = (
    derivation {
      inherit system;
      name = "bootstrap-archive";
      pname = "bootstrap-archive";
      version = "9.9.9";
      builder = "${bootstrapFiles.unpack}/libexec/ld-elf.so.1";
      args = [
        "${bootstrapFiles.unpack}/bin/bash"
        ./unpack-bootstrap-files.sh
      ];
      LD_LIBRARY_PATH = "${bootstrapFiles.unpack}/lib";
      src = bootstrapFiles.unpack;
      inherit (bootstrapFiles) bootstrapTools;
    }
  );

  linkBootstrap = (
    attrs:
    derivation (
      attrs
      // {
        inherit system;
        name = attrs.name or (baseNameOf (builtins.elemAt attrs.paths 0));
        src = bootstrapArchive;
        builder = "${bootstrapArchive}/bin/bash";
        # this script will prefer to link files instead of copying them.
        # this prevents clang in particular, but possibly others, from calling readlink(argv[0])
        # and obtaining dependencies, ld(1) in particular, from there instead of $PATH.
        args = [ ./linkBootstrap.sh ];
        PATH = "${bootstrapArchive}/bin";
        paths = attrs.paths;
      }
    )
  );

  # commented linkBootstrap entries are provided but unused
  bootstrapTools = {
    expand-response-params = "";
    bsdcp = linkBootstrap { paths = [ "bin/bsdcp" ]; };
    patchelf = linkBootstrap { paths = [ "bin/patchelf" ]; };
    bashNonInteractive = linkBootstrap {
      paths = [
        "bin/bash"
        "bin/sh"
      ];
      shell = "bin/bash";
      shellPath = "/bin/bash";
    };
    curl = linkBootstrap {
      paths = [
        "bin/curl"
      ];
    };
    llvmPackages = {
      clang-unwrapped = linkBootstrap {
        paths = [
          "bin/clang"
          "bin/clang++"
          "bin/cpp"
          "lib/clang"
        ];
        # SYNCME: this version number must be synced with the one in make-bootstrap-tools.nix
        version = "18";
      };
      libunwind = linkBootstrap {
        name = "libunwind";
        paths = [
          "lib/libunwind.a"
          "lib/libunwind.so"
          "lib/libunwind.so.1"
          "lib/libunwind.so.1.0"
          "lib/libunwind_shared.so"
        ];
      };
    };
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
        "stdbuf"
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
    diffutils = linkBootstrap {
      name = "diffutils";
      paths = map (str: "bin/" + str) [
        "diff"
        "cmp"
        #"diff3"
        #"sdiff"
      ];
    };
    findutils = linkBootstrap {
      name = "findutils";
      paths = [
        "bin/find"
        "bin/xargs"
      ];
    };
    iconv = linkBootstrap { paths = [ "bin/iconv" ]; };
    libiconv = linkBootstrap { paths = [ "include/iconv.h" ]; };
    patch = linkBootstrap { paths = [ "bin/patch" ]; };
    gnutar = linkBootstrap { paths = [ "bin/tar" ]; };
    gawk = linkBootstrap {
      paths = [
        "bin/awk"
        "bin/gawk"
      ];
    };
    gnumake = linkBootstrap { paths = [ "bin/make" ]; };
    gnugrep = linkBootstrap {
      paths = [
        "bin/grep"
        "bin/egrep"
        "bin/fgrep"
      ];
    };
    gnused = linkBootstrap { paths = [ "bin/sed" ]; };
    gzip = linkBootstrap {
      paths = [
        "bin/gzip"
        #"bin/gunzip"
      ];
    };
    bzip2 = linkBootstrap {
      paths = [
        "bin/bzip2"
        "lib/libbz2.so"
        "lib/libbz2.so.1"
      ];
    };
    xz = linkBootstrap {
      paths = [
        "bin/xz"
        "bin/unxz"
        "lib/liblzma.so"
        "lib/liblzma.so.5"
      ];
    };
    binutils-unwrapped = linkBootstrap {
      name = "binutils";
      paths = map (str: "bin/" + str) [
        "ld"
        #"as"
        #"addr2line"
        "ar"
        #"c++filt"
        #"elfedit"
        #"gprof"
        #"objdump"
        "nm"
        "objcopy"
        "ranlib"
        "readelf"
        "size"
        "strings"
        "strip"
      ];
    };
    freebsd = {
      locales = linkBootstrap { paths = [ "share/locale" ]; };
      libc = linkBootstrap {
        name = "bootstrapLibs";
        paths = [
          "lib/Scrt1.o"
          "lib/crt1.o"
          "lib/crtbegin.o"
          "lib/crtbeginS.o"
          "lib/crtbeginT.o"
          "lib/crtend.o"
          "lib/crtendS.o"
          "lib/crti.o"
          "lib/crtn.o"
          "lib/libc++.a"
          "lib/libc++.so"
          "lib/libc++.so.1"
          "lib/libc.a"
          "lib/libc.so"
          "lib/libc.so.7"
          "lib/libc_nonshared.a"
          "lib/libcrypt.so"
          "lib/libcrypt.so.5"
          "lib/libcxxrt.a"
          "lib/libcxxrt.so"
          "lib/libcxxrt.so.1"
          "lib/libdevstat.so"
          "lib/libdevstat.so.7"
          "lib/libdl.so"
          "lib/libdl.so.1"
          "lib/libelf.so"
          "lib/libelf.so.2"
          "lib/libexecinfo.so"
          "lib/libexecinfo.so.1"
          "lib/libgcc.a"
          "lib/libgcc_eh.a"
          "lib/libgcc_s.so"
          "lib/libgcc_s.so.1"
          "lib/libkvm.so"
          "lib/libkvm.so.7"
          "lib/libm.a"
          "lib/libm.so"
          "lib/libm.so.5"
          "lib/libmd.so"
          "lib/libmd.so.6"
          "lib/libncurses.so"
          "lib/libncurses.so.6"
          "lib/libncursesw.so"
          "lib/libncursesw.so.6"
          "lib/libpthread.so"
          "lib/librt.so"
          "lib/librt.so.1"
          "lib/libthr.so"
          "lib/libthr.so.3"
          "lib/libutil.so"
          "lib/libutil.so.9"
          "lib/libxnet.so"
          "include"
          "share"
          "libexec"
        ];
        pname = "libs";
        version = "bootstrap";
      };
    };
  };

  mkStdenv =
    {
      name ? "freebsd",
      overrides ?
        prevStage: super: self:
        { },
      hascxx ? true,
    }:
    prevStage:
    let
      bsdcp =
        prevStage.bsdcp or (prevStage.runCommand "bsdcp" { }
          "mkdir -p $out/bin; cp ${prevStage.freebsd.cp}/bin/cp $out/bin/bsdcp"
        );
      initialPath = with prevStage; [
        coreutils
        gnutar
        findutils
        gnumake
        gnused
        patchelf
        gnugrep
        gawk
        diffutils
        patch
        bashNonInteractive
        xz
        gzip
        bzip2
        bsdcp
      ];
      shell = "${prevStage.bashNonInteractive}/bin/bash";
      stdenvNoCC = import ../generic {
        inherit
          config
          initialPath
          shell
          fetchurlBoot
          ;
        name = "stdenvNoCC-${name}";
        buildPlatform = localSystem;
        hostPlatform = localSystem;
        targetPlatform = localSystem;
        cc = null;
      };
      fetchurlBoot = import ../../build-support/fetchurl {
        inherit lib stdenvNoCC;
        inherit (prevStage) curl;
        inherit (config) hashedMirrors rewriteURL;
      };
      stdenv = import ../generic {
        inherit
          config
          initialPath
          shell
          fetchurlBoot
          ;
        name = "stdenv-${name}";
        buildPlatform = localSystem;
        hostPlatform = localSystem;
        targetPlatform = localSystem;
        extraNativeBuildInputs = [
          ./unpack-source.sh
          ./always-patchelf.sh
        ];
        cc = lib.makeOverridable (import ../../build-support/cc-wrapper) {
          inherit lib stdenvNoCC;
          name = "${name}-cc";
          inherit (prevStage.freebsd) libc;
          inherit (prevStage) gnugrep coreutils expand-response-params;
          libcxx = prevStage.llvmPackages.libcxx or null;
          runtimeShell = shell;
          propagateDoc = false;
          nativeTools = false;
          nativeLibc = false;
          cc = prevStage.llvmPackages.clang-unwrapped;
          isClang = true;
          extraPackages = lib.optionals hascxx [
            prevStage.llvmPackages.compiler-rt
          ];
          nixSupport = {
            libcxx-cxxflags = lib.optionals (!hascxx) [ "-isystem ${prevStage.freebsd.libc}/include/c++/v1" ];
          };
          extraBuildCommands = lib.optionalString hascxx (
            mkExtraBuildCommands prevStage.llvmPackages.clang-unwrapped prevStage.llvmPackages.compiler-rt
          );
          bintools = lib.makeOverridable (import ../../build-support/bintools-wrapper) {
            inherit lib stdenvNoCC;
            name = "${name}-bintools";
            inherit (prevStage.freebsd) libc;
            inherit (prevStage) gnugrep coreutils expand-response-params;
            runtimeShell = shell;
            bintools = (prevStage.llvmPackages or { }).bintools-unwrapped or prevStage.binutils-unwrapped;
            propagateDoc = false;
            nativeTools = false;
            nativeLibc = false;
          };
        };
        overrides = overrides prevStage;
        preHook = ''
          export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
          export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
          export PATH_LOCALE=${prevStage.freebsd.localesReal or prevStage.freebsd.locales}/share/locale
        ''
        + lib.optionalString (prevStage.freebsd ? libiconvModules) ''
          export PATH_I18NMODULE=${prevStage.freebsd.libiconvModules}/lib/i18n
        '';
      };
    in
    {
      inherit config overlays stdenv;
    };
in
[
  (
    { }:
    mkStdenv {
      name = "freebsd-boot-0";
      hascxx = false;
      overrides = prevStage: self: super: {
        # this one's goal is to build foundational libs like libc and libcxx. we want to override literally every possible bin package we can with bootstrap tools
        # we CAN'T import LLVM because the compiler built here is used to build the final compiler and the final compiler must not be built by the bootstrap compiler
        inherit (bootstrapTools)
          patchelf
          bashNonInteractive
          curl
          coreutils
          diffutils
          findutils
          iconv
          libiconv
          patch
          gnutar
          gawk
          gnumake
          gnugrep
          gnused
          gzip
          bzip2
          xz
          ;
        binutils-unwrapped = removeAttrs bootstrapTools.binutils-unwrapped [ "src" ];
        fetchurl = import ../../build-support/fetchurl {
          inherit lib;
          inherit (self) stdenvNoCC;
          inherit (prevStage) curl;
          inherit (config) hashedMirrors rewriteURL;
        };
        gettext = super.gettext.overrideAttrs {
          NIX_CFLAGS_COMPILE = "-DHAVE_ICONV=1"; # we clearly have iconv. what do you want?
        };
        curlReal = super.curl;
        tzdata = super.tzdata.overrideAttrs { NIX_CFLAGS_COMPILE = "-DHAVE_GETTEXT=0"; };

        # make it so libcxx/libunwind are built in this stdenv and not the next
        freebsd = super.freebsd.overrideScope (
          self': super': {
            inherit (prevStage.freebsd) locales;
            stdenvNoLibcxx = self.overrideCC (self.stdenv // { name = "stdenv-freebsd-boot-0.4"; }) (
              self.stdenv.cc.override {
                name = "freebsd-boot-0.4-cc";
                libc = self.freebsd.libc;
                bintools = self.stdenv.cc.bintools.override {
                  name = "freebsd-boot-0.4-bintools";
                  libc = self.freebsd.libc;
                };
              }
            );
          }
        );
        llvmPackages = super.llvmPackages // {
          libcxx =
            (super.llvmPackages.libcxx.override {
              stdenv = self.overrideCC (self.stdenv // { name = "stdenv-freebsd-boot-0.5"; }) (
                self.stdenv.cc.override {
                  name = "freebsd-boot-0.5-cc";
                  libc = self.freebsd.libc;
                  bintools = self.stdenv.cc.bintools.override {
                    name = "freebsd-boot-0.5-bintools";
                    libc = self.freebsd.libc;
                  };
                  extraPackages = [
                    self.llvmPackages.compiler-rt
                  ];
                  extraBuildCommands = mkExtraBuildCommands self.llvmPackages.clang-unwrapped self.llvmPackages.compiler-rt;
                }
              );
            }).overrideAttrs
              (
                self': super': {
                  NIX_CFLAGS_COMPILE = "-nostdlib++";
                  NIX_LDFLAGS = "--allow-shlib-undefined";
                  cmakeFlags = builtins.filter (x: x != "-DCMAKE_SHARED_LINKER_FLAGS=-nostdlib") super'.cmakeFlags;
                }
              );
        };
      };
    } bootstrapTools
  )
  (mkStdenv {
    name = "freebsd-boot-1";
    overrides = prevStage: self: super: {
      # this one's goal is to build all the tools that get imported into the final stdenv.
      # we can import the foundational libs from boot-0
      # we can import bins and libs that DON'T get imported OR LINKED into the final stdenv from boot-0
      curl = prevStage.curlReal;
      inherit (prevStage)
        fetchurl
        python3
        bison
        perl
        cmake
        ninja
        ;
      fetchurlReal = super.fetchurl;
      freebsd = super.freebsd.overrideScope (
        self': super': {
          locales = prevStage.freebsd.locales;
          localesReal = super'.locales;
          libc = prevStage.freebsd.libc;
        }
      );
      llvmPackages = super.llvmPackages // {
        libcxx = prevStage.llvmPackages.libcxx;
      };
    };
  })
  (mkStdenv {
    name = "freebsd";
    overrides = prevStage: self: super: {
      __bootstrapArchive = bootstrapArchive;
      fetchurl = prevStage.fetchurlReal;
      freebsd = super.freebsd.overrideScope (
        self': super': { localesPrev = prevStage.freebsd.localesReal; }
      );
    };
  })
]
