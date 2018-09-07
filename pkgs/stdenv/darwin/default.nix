{ lib
, localSystem, crossSystem, config, overlays

# Allow passing in bootstrap files directly so we can test the stdenv bootstrap process when changing the bootstrap tools
, bootstrapFiles ? let
  fetch = { file, sha256, executable ? true }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-darwin/x86_64/d5bdfcbfe6346761a332918a267e82799ec954d2/${file}";
    inherit (localSystem) system;
    inherit sha256 executable;
  }; in {
    sh      = fetch { file = "sh";    sha256 = "07wm33f1yzfpcd3rh42f8g096k4cvv7g65p968j28agzmm2s7s8m"; };
    bzip2   = fetch { file = "bzip2"; sha256 = "0y9ri2aprkrp2dkzm6229l0mw4rxr2jy7vvh3d8mxv2698v2kdbm"; };
    mkdir   = fetch { file = "mkdir"; sha256 = "0sb07xpy66ws6f2jfnpjibyimzb71al8n8c6y4nr8h50al3g90nr"; };
    cpio    = fetch { file = "cpio";  sha256 = "0r5c54hg678w7zydx27bzl9p3v9fs25y5ix6vdfi1ilqim7xh65n"; };
    tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "18hp5w6klr8g307ap4368r255qpzg9r0vwg9vqvj8f2zy1xilcjf"; executable = false; };
  }
}:

assert crossSystem == null;

let
  inherit (localSystem) system platform;

  commonImpureHostDeps = [
    "/bin/sh"
    "/usr/lib/libSystem.B.dylib"
    "/usr/lib/system/libunc.dylib" # This dependency is "hidden", so our scanning code doesn't pick it up
  ];
in rec {
  commonPreHook = ''
    export NIX_ENFORCE_PURITY="''${NIX_ENFORCE_PURITY-1}"
    export NIX_ENFORCE_NO_NATIVE="''${NIX_ENFORCE_NO_NATIVE-1}"
    export NIX_IGNORE_LD_THROUGH_GCC=1
    stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
    export MACOSX_DEPLOYMENT_TARGET=10.10
    export SDKROOT=
    export CMAKE_OSX_ARCHITECTURES=x86_64
    # Workaround for https://openradar.appspot.com/22671534 on 10.11.
    export gl_cv_func_getcwd_abort_bug=no
  '';

  bootstrapTools = derivation rec {
    inherit system;

    name    = "bootstrap-tools";
    builder = bootstrapFiles.sh; # Not a filename! Attribute 'sh' on bootstrapFiles
    args    = [ ./unpack-bootstrap-tools.sh ];

    inherit (bootstrapFiles) mkdir bzip2 cpio tarball;
    reexportedLibrariesFile =
      ../../os-specific/darwin/apple-source-releases/Libsystem/reexported_libraries;

    __impureHostDeps = commonImpureHostDeps;
  };

  stageFun = step: last: {shell             ? "${bootstrapTools}/bin/bash",
                          overrides         ? (self: super: {}),
                          extraPreHook      ? "",
                          extraNativeBuildInputs,
                          extraBuildInputs,
                          libcxx,
                          allowedRequisites ? null}:
    let
      name = "bootstrap-stage${toString step}";

      buildPackages = lib.optionalAttrs (last ? stdenv) {
        inherit (last) stdenv;
      };

      coreutils = { name = "${name}-coreutils"; outPath = bootstrapTools; };
      gnugrep   = { name = "${name}-gnugrep";   outPath = bootstrapTools; };

      bintools = import ../../build-support/bintools-wrapper {
        inherit shell;
        inherit (last) stdenvNoCC;

        nativeTools  = false;
        nativeLibc   = false;
        inherit buildPackages coreutils gnugrep;
        libc         = last.pkgs.darwin.Libsystem;
        bintools     = { name = "${name}-binutils"; outPath = bootstrapTools; };
      };

      cc = if isNull last then "/dev/null" else import ../../build-support/cc-wrapper {
        inherit shell;
        inherit (last) stdenvNoCC;

        extraPackages = lib.optional (libcxx != null) libcxx;

        nativeTools  = false;
        propagateDoc = false;
        nativeLibc   = false;
        inherit buildPackages coreutils gnugrep bintools;
        libc         = last.pkgs.darwin.Libsystem;
        isClang      = true;
        cc           = { name = "${name}-clang"; outPath = bootstrapTools; };
      };

      thisStdenv = import ../generic {
        name = "${name}-stdenv-darwin";

        inherit config shell extraNativeBuildInputs extraBuildInputs;
        allowedRequisites = if allowedRequisites == null then null else allowedRequisites ++ [
          cc.expand-response-params cc.bintools
        ];

        buildPlatform = localSystem;
        hostPlatform = localSystem;
        targetPlatform = localSystem;

        inherit cc;

        preHook = lib.optionalString (shell == "${bootstrapTools}/bin/bash") ''
          # Don't patch #!/interpreter because it leads to retained
          # dependencies on the bootstrapTools in the final stdenv.
          dontPatchShebangs=1
        '' + ''
          ${commonPreHook}
          ${extraPreHook}
        '';
        initialPath  = [ bootstrapTools ];

        fetchurlBoot = import ../../build-support/fetchurl {
          inherit lib;
          stdenvNoCC = stage0.stdenv;
          curl = bootstrapTools;
        };

        # The stdenvs themselves don't use mkDerivation, so I need to specify this here
        __stdenvImpureHostDeps = commonImpureHostDeps;
        __extraImpureHostDeps = commonImpureHostDeps;

        extraAttrs = {
          inherit platform;
          parent = last;

          # This is used all over the place so I figured I'd just leave it here for now
          secure-format-patch = ./darwin-secure-format.patch;
        };
        overrides  = self: super: (overrides self super) // { fetchurl = thisStdenv.fetchurlBoot; };
      };

    in {
      inherit config overlays;
      stdenv = thisStdenv;
    };

  stage0 = stageFun 0 null {
    overrides = self: super: with stage0; rec {
      darwin = super.darwin // {
        Libsystem = stdenv.mkDerivation {
          name = "bootstrap-stage0-Libsystem";
          buildCommand = ''
            mkdir -p $out
            ln -s ${bootstrapTools}/lib $out/lib
            ln -s ${bootstrapTools}/include-Libsystem $out/include
          '';
        };
        dyld = bootstrapTools;
      };

      llvmPackages_5 = {
        libcxx = stdenv.mkDerivation {
          name = "bootstrap-stage0-libcxx";
          phases = [ "installPhase" "fixupPhase" ];
          installPhase = ''
            mkdir -p $out/lib $out/include
            ln -s ${bootstrapTools}/lib/libc++.dylib $out/lib/libc++.dylib
            ln -s ${bootstrapTools}/include/c++      $out/include/c++
          '';
          linkCxxAbi = false;
          setupHook = ../../development/compilers/llvm/3.9/libc++/setup-hook.sh;
        };

        libcxxabi = stdenv.mkDerivation {
          name = "bootstrap-stage0-libcxxabi";
          buildCommand = ''
            mkdir -p $out/lib
            ln -s ${bootstrapTools}/lib/libc++abi.dylib $out/lib/libc++abi.dylib
          '';
        };
      };
    };

    extraNativeBuildInputs = [];
    extraBuildInputs = [];
    libcxx = null;
  };

  stage1 = prevStage: let
    persistent = self: super: with prevStage; {
      cmake = super.cmake.override {
        majorVersion = "3.9";  # FIXME: update ApplicationServices patch
        isBootstrap = true;
        useSharedLibraries = false;
      };

      python = super.callPackage ../../development/interpreters/python/cpython/2.7/boot.nix {
        CF = null;  # use CoreFoundation from bootstrap-tools
        configd = null;
      };
    };
  in with prevStage; stageFun 1 prevStage {
    extraPreHook = "export NIX_CFLAGS_COMPILE+=\" -F${bootstrapTools}/Library/Frameworks\"";
    extraNativeBuildInputs = [];
    extraBuildInputs = [ ];
    libcxx = pkgs.libcxx;

    allowedRequisites =
      [ bootstrapTools ] ++ (with pkgs; [ libcxx libcxxabi ]) ++ [ pkgs.darwin.Libsystem ];

    overrides = persistent;
  };

  stage2 = prevStage: let
    persistent = self: super: with prevStage; {
      inherit
        zlib patchutils m4 scons flex perl bison unifdef unzip openssl python
        libxml2 gettext sharutils gmp libarchive ncurses pkg-config libedit groff
        openssh sqlite sed serf openldap db cyrus-sasl expat apr-util subversion xz
        findfreetype libssh curl cmake autoconf automake libtool ed cpio coreutils;

      darwin = super.darwin // {
        inherit (darwin)
          dyld Libsystem xnu configd ICU libdispatch libclosure launchd;
      };
    };
  in with prevStage; stageFun 2 prevStage {
    extraPreHook = ''
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';

    extraNativeBuildInputs = [ pkgs.xz ];
    extraBuildInputs = [ pkgs.darwin.CF ];
    libcxx = pkgs.libcxx;

    allowedRequisites =
      [ bootstrapTools ] ++
      (with pkgs; [ xz.bin xz.out libcxx libcxxabi ]) ++
      (with pkgs.darwin; [ dyld Libsystem CF ICU locale ]);

    overrides = persistent;
  };

  stage3 = prevStage: let
    persistent = self: super: with prevStage; {
      inherit
        patchutils m4 scons flex perl bison unifdef unzip openssl python
        gettext sharutils libarchive pkg-config groff bash subversion
        openssh sqlite sed serf openldap db cyrus-sasl expat apr-util
        findfreetype libssh curl cmake autoconf automake libtool cpio;

      # Avoid pulling in a full python and it's extra dependencies for the llvm/clang builds.
      libxml2 = super.libxml2.override { pythonSupport = false; };

      llvmPackages_5 = super.llvmPackages_5 // (let
        libraries = super.llvmPackages_5.libraries.extend (_: _: {
          inherit (llvmPackages_5) libcxx libcxxabi;
        });
      in { inherit libraries; } // libraries);

      darwin = super.darwin // {
        inherit (darwin)
          dyld Libsystem xnu configd libdispatch libclosure launchd libiconv locale;
      };
    };
  in with prevStage; stageFun 3 prevStage {
    shell = "${pkgs.bash}/bin/bash";

    # We have a valid shell here (this one has no bootstrap-tools runtime deps) so stageFun
    # enables patchShebangs above. Unfortunately, patchShebangs ignores our $SHELL setting
    # and instead goes by $PATH, which happens to contain bootstrapTools. So it goes and
    # patches our shebangs back to point at bootstrapTools. This makes sure bash comes first.
    extraNativeBuildInputs = with pkgs; [ xz pkgs.bash ];
    extraBuildInputs = [ pkgs.darwin.CF ];
    libcxx = pkgs.libcxx;

    extraPreHook = ''
      export PATH=${pkgs.bash}/bin:$PATH
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';

    allowedRequisites =
      [ bootstrapTools ] ++
      (with pkgs; [ xz.bin xz.out bash libcxx libcxxabi ]) ++
      (with pkgs.darwin; [ dyld ICU Libsystem locale ]);

    overrides = persistent;
  };

  stage4 = prevStage: let
    persistent = self: super: with prevStage; {
      inherit
        gnumake gzip gnused bzip2 gawk ed xz patch bash
        ncurses libffi zlib gmp pcre gnugrep
        coreutils findutils diffutils patchutils;

      # Hack to make sure we don't link ncurses in bootstrap tools. The proper
      # solution is to avoid passing -L/nix-store/...-bootstrap-tools/lib,
      # quite a sledgehammer just to get the C runtime.
      gettext = super.gettext.overrideAttrs (drv: {
        configureFlags = drv.configureFlags ++ [
          "--disable-curses"
        ];
      });

      llvmPackages_5 = super.llvmPackages_5 // (let
        tools = super.llvmPackages_5.tools.extend (llvmSelf: _: {
          inherit (llvmPackages_5) llvm clang-unwrapped;
        });
        libraries = super.llvmPackages_5.libraries.extend (llvmSelf: _: {
          inherit (llvmPackages_5) libcxx libcxxabi compiler-rt;
        });
      in { inherit tools libraries; } // tools // libraries);

      darwin = super.darwin // {
        inherit (darwin) dyld Libsystem libiconv locale;
      };
    };
  in with prevStage; stageFun 4 prevStage {
    shell = "${pkgs.bash}/bin/bash";
    extraNativeBuildInputs = with pkgs; [ xz pkgs.bash ];
    extraBuildInputs = [ pkgs.darwin.CF ];
    libcxx = pkgs.libcxx;

    extraPreHook = ''
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';
    overrides = persistent;
  };

  stdenvDarwin = prevStage: let
    pkgs = prevStage;
    persistent = self: super: with prevStage; {
      inherit
        gnumake gzip gnused bzip2 gawk ed xz patch bash
        ncurses libffi zlib llvm gmp pcre gnugrep
        coreutils findutils diffutils patchutils;

      llvmPackages_5 = super.llvmPackages_5 // (let
        tools = super.llvmPackages_5.tools.extend (_: super: {
          inherit (llvmPackages_5) llvm clang-unwrapped;
        });
        libraries = super.llvmPackages_5.libraries.extend (_: _: {
          inherit (llvmPackages_5) compiler-rt libcxx libcxxabi;
        });
      in { inherit tools libraries; } // tools // libraries);

      darwin = super.darwin // {
        inherit (darwin) dyld ICU Libsystem libiconv;
      } // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
        inherit (darwin) binutils binutils-unwrapped cctools;
      };
    } // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
      # Need to get rid of these when cross-compiling.
      inherit binutils binutils-unwrapped;
    };
  in import ../generic rec {
    name = "stdenv-darwin";

    inherit config;
    inherit (pkgs.stdenv) fetchurlBoot;

    buildPlatform = localSystem;
    hostPlatform = localSystem;
    targetPlatform = localSystem;

    preHook = commonPreHook + ''
      export NIX_COREFOUNDATION_RPATH=${pkgs.darwin.CF}/Library/Frameworks
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';

    __stdenvImpureHostDeps = commonImpureHostDeps;
    __extraImpureHostDeps = commonImpureHostDeps;

    initialPath = import ../common-path.nix { inherit pkgs; };
    shell       = "${pkgs.bash}/bin/bash";

    cc = pkgs.llvmPackages.libcxxClang.override {
      cc = pkgs.llvmPackages.clang-unwrapped;
    };

    extraNativeBuildInputs = [];
    extraBuildInputs = [ pkgs.darwin.CF ];

    extraAttrs = {
      inherit platform bootstrapTools;
      libc         = pkgs.darwin.Libsystem;
      shellPackage = pkgs.bash;

      # This is used all over the place so I figured I'd just leave it here for now
      secure-format-patch = ./darwin-secure-format.patch;
    };

    allowedRequisites = (with pkgs; [
      xz.out xz.bin libcxx libcxxabi gmp.out gnumake findutils bzip2.out
      bzip2.bin llvmPackages.llvm llvmPackages.llvm.lib llvmPackages.compiler-rt llvmPackages.compiler-rt.dev
      zlib.out zlib.dev libffi.out coreutils ed diffutils gnutar
      gzip ncurses.out ncurses.dev ncurses.man gnused bash gawk
      gnugrep llvmPackages.clang-unwrapped llvmPackages.clang-unwrapped.lib patch pcre.out gettext
      binutils.bintools darwin.binutils darwin.binutils.bintools
      cc.expand-response-params
    ]) ++ (with pkgs.darwin; [
      dyld Libsystem CF cctools ICU libiconv locale
    ]);

    overrides = lib.composeExtensions persistent (self: super: {
      clang = cc;
      llvmPackages = super.llvmPackages // { clang = cc; };
      inherit cc;

      darwin = super.darwin // {
        xnu = super.darwin.xnu.override { python = super.python.override { configd = null; }; };
      };
    });
  };

  stagesDarwin = [
    ({}: stage0)
    stage1
    stage2
    stage3
    stage4
    (prevStage: {
      inherit config overlays;
      stdenv = stdenvDarwin prevStage;
    })
  ];
}
