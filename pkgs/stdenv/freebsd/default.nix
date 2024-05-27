# afaik the longest dependency chain is stdenv -> stdenv-1#coreutils -> stdenv-1#gmp -> stdenv-0#libcxx -> stdenv-0#libc
# this is only possible through aggressive hacking to make libcxx build with stdenv-0#libc instead of bootstrapTools.libc.
{
  lib,
  localSystem,
  crossSystem,
  config,
  overlays,
  crossOverlays ? [ ],
}:

assert crossSystem == localSystem;
let
  inherit (localSystem) system;
  bootstrap-urls-table = {
    x86_64-freebsd = {
      stage0 = {
        url = "http://192.168.122.1:8000/stage0.nar.xz";
        hash = "sha256-iGPBcwzDLJFroXwE/ADW+aUevywZCOher4mg9Ysx2j4=";
        name = "bootstrap-files0";
        unpack = true;
      };
      stage1 = {
        url = "http://192.168.122.1:8000/stage1.tar.xz";
        hash = "sha256-i0VBzbMPnSSmPjh5CYOQXTYCbSBbfa5omA0xZ2fjDlU=";
        name = "bootstrap-files1.tar.xz";
      };
    };
  };
  fetchurlBoot = import <nix/fetchurl.nix>;
  bootstrap-files = builtins.mapAttrs (k: fetchurlBoot) bootstrap-urls-table.${localSystem.system};
  mkExtraBuildCommands0 = cc: ''
    rsrc="$out/resource-root"
    mkdir "$rsrc"
    ln -s "${lib.getLib cc}/lib/clang/16/include" "$rsrc"
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
      builder = "${bootstrap-files.stage0}/libexec/ld-elf.so.1";
      args = [ "${bootstrap-files.stage0}/bin/bash" ./unpack-bootstrap-files.sh ];
      LD_LIBRARY_PATH = "${bootstrap-files.stage0}/lib";
      src = bootstrap-files.stage0;
      inherit (bootstrap-files) stage1;
    }
  );

  linkBS = (
    attrs:
    derivation (
      attrs
      // {
        inherit system;
        name = attrs.name or (builtins.baseNameOf (builtins.elemAt attrs.paths 0));
        src = bootstrapArchive;
        builder = "${bootstrapArchive}/bin/bash";
        args = [ ./linkBS.sh ];
        PATH = "${bootstrapArchive}/bin";
        paths = attrs.paths;
      }
    )
  );

  # commented linkBS entries are provided but unused
  bootstrapTools = {
    expand-response-params = "";
    bsdcp = linkBS { paths = [ "bin/bsdcp" ]; };
    patchelf = linkBS { paths = [ "bin/patchelf" ]; };
    bash = linkBS {
      paths = [
        "bin/bash"
        "bin/sh"
      ];
      shell = "bin/bash";
      shellPath = "/bin/bash";
    };
    curl = linkBS {
      paths = [
        "bin/curl"
      ];
    };
    llvmPackages = {
      clang-unwrapped = linkBS {
        paths = [
          "bin/clang"
          "bin/clang++"
          "bin/cpp"
        ];
        version = "16";
      };
      libunwind = linkBS {
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
    coreutils = linkBS {
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
    diffutils = linkBS {
      name = "diffutils";
      paths = map (str: "bin/" + str) [
        "diff"
        "cmp"
        #"diff3"
        #"sdiff"
      ];
    };
    findutils = linkBS {
      name = "findutils";
      paths = [
        "bin/find"
        "bin/xargs"
      ];
    };
    iconv = linkBS { paths = [ "bin/iconv" ]; };
    patch = linkBS { paths = [ "bin/patch" ]; };
    gnutar = linkBS { paths = [ "bin/tar" ]; };
    gawk = linkBS {
      paths = [
        "bin/awk"
        "bin/gawk"
      ];
    };
    gnumake = linkBS { paths = [ "bin/make" ]; };
    gnugrep = linkBS {
      paths = [
        "bin/grep"
        "bin/egrep"
        "bin/fgrep"
      ];
    };
    gnused = linkBS { paths = [ "bin/sed" ]; };
    gzip = linkBS {
      paths = [
        "bin/gzip"
        #"bin/gunzip"
      ];
    };
    bzip2 = linkBS { paths = [ "bin/bzip2" ]; };
    xz = linkBS {
      paths = [
        "bin/xz"
        "bin/unxz"
      ];
    };
    cacert = linkBS {
      paths = [
        "etc/ssl/certs"
        "nix-support/setup-hook"
      ];
    };
    binutils-unwrapped = linkBS {
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
      locales = linkBS { paths = [ "share/locale" ]; };
      libc = linkBS {
        name = "bootstrapLibs";
        paths = [
          "lib"
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
        bash
        xz
        gzip
        bzip2
        bsdcp
      ];
      shell = "${prevStage.bash}/bin/bash";
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
            bintools = prevStage.binutils-unwrapped;
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
          bash
          curl
          coreutils
          diffutils
          findutils
          iconv
          patch
          gnutar
          gawk
          gnumake
          gnugrep
          gnused
          gzip
          bzip2
          xz
          cacert
          ;
        binutils-unwrapped = builtins.removeAttrs bootstrapTools.binutils-unwrapped [ "src" ];
        fetchurl = import ../../build-support/fetchurl {
          inherit lib;
          inherit (self) stdenvNoCC;
          inherit (prevStage) curl;
        };
        gettext = super.gettext.overrideAttrs {
          NIX_CFLAGS_COMPILE = "-DHAVE_ICONV=1"; # we clearly have iconv. what do you want?
        };
        curlReal = super.curl;
        tzdata = super.tzdata.overrideAttrs { NIX_CFLAGS_COMPILE = "-DHAVE_GETTEXT=0"; };

        # make it so libcxx/libunwind are built in this stdenv and not the next
        freebsd = super.freebsd.overrideScope (self': super': {
          inherit (prevStage.freebsd) locales;
              stdenvNoLibcxx =
                self.overrideCC (self.stdenv // { name = "stdenv-freebsd-boot-0.4"; })
                  (
                    self.stdenv.cc.override {
                      name = "freebsd-boot-0.4-cc";
                      libc = self.freebsd.libc;
                      bintools = self.stdenv.cc.bintools.override {
                        name = "freebsd-boot-0.4-bintools";
                        libc = self.freebsd.libc;
                      };
                    }
                  );
        });
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
      curlReal = super.curl;
      cacert = prevStage.cacert;
      inherit (prevStage)
        fetchurl
        python3
        bison
        perl
        cmake
        ninja
        ;
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
      curl = prevStage.curlReal;
      cacert = prevStage.cacert;
      inherit (prevStage) fetchurl;
      freebsd = super.freebsd.overrideScope (
        self': super': { localesPrev = prevStage.freebsd.localesReal; }
      );
      haskellPackages = super.haskellPackages.override {
        overrides = (
          self: super: {
            digest = super.digest.overrideAttrs {
              postPatch = ''
                sed -E -i -e 's/ && !os\(freebsd\)//' digest.cabal
              '';
            };
          }
        );
      };
    };
  })
]
