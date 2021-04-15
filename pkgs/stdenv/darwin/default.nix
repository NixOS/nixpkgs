{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
# Allow passing in bootstrap files directly so we can test the stdenv bootstrap process when changing the bootstrap tools
, bootstrapFiles ? let
  fetch = { file, sha256, executable ? true }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-darwin/x86_64/5ab5783e4f46c373c6de84deac9ad59b608bb2e6/${file}";
    inherit (localSystem) system;
    inherit sha256 executable;
  }; in {
    sh      = fetch { file = "sh";    sha256 = "sha256-nbb4XEk3go7ttiWrQyKQMLzPr+qUnwnHkWMtVCZsMCs="; };
    bzip2   = fetch { file = "bzip2"; sha256 = "sha256-ybnA+JWrKhXSfn20+GVKXkHFTp2Zt79hat8hAVmsUOc="; };
    mkdir   = fetch { file = "mkdir"; sha256 = "sha256-nmvMxmfcY41/60Z/E8L9u0vgePW5l30Dqw1z+Nr02Hk="; };
    cpio    = fetch { file = "cpio";  sha256 = "sha256-cB36rN3NLj19Tk37Kc5bodMFMO+mCpEQkKKo0AEMkaU="; };
    tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "sha256-kh2vKmjCr/HvR06czZbxUxV5KDRxSF27M6nN3cyofRI="; executable = false; };
  }
}:

assert crossSystem == localSystem;

let
  inherit (localSystem) system;

  bootstrapClangVersion = "7.1.0";

  commonImpureHostDeps = [
    "/bin/sh"
    "/usr/lib/libSystem.B.dylib"
    "/usr/lib/system/libunc.dylib" # This dependency is "hidden", so our scanning code doesn't pick it up
  ];
in rec {
  commonPreHook = ''
    export NIX_ENFORCE_NO_NATIVE=''${NIX_ENFORCE_NO_NATIVE-1}
    export NIX_ENFORCE_PURITY=''${NIX_ENFORCE_PURITY-1}
    export NIX_IGNORE_LD_THROUGH_GCC=1
    unset SDKROOT

    # Workaround for https://openradar.appspot.com/22671534 on 10.11.
    export gl_cv_func_getcwd_abort_bug=no

    stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
  '';

  bootstrapTools = derivation {
    inherit system;

    name    = "bootstrap-tools";
    builder = bootstrapFiles.sh; # Not a filename! Attribute 'sh' on bootstrapFiles
    args    = [ ./unpack-bootstrap-tools.sh ];

    inherit (bootstrapFiles) mkdir bzip2 cpio tarball;

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

      mkExtraBuildCommands = cc: ''
        rsrc="$out/resource-root"
        mkdir "$rsrc"
        ln -s "${cc}/lib/clang/${cc.version}/include" "$rsrc"
        ln -s "${last.pkgs.llvmPackages_7.compiler-rt.out}/lib" "$rsrc/lib"
        echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
      '';

      mkCC = overrides: import ../../build-support/cc-wrapper (
        let args = {
          inherit lib shell;
          inherit (last) stdenvNoCC;

          nativeTools  = false;
          nativeLibc   = false;
          inherit buildPackages libcxx;
          inherit (last.pkgs) coreutils gnugrep;
          bintools     = last.pkgs.darwin.binutils;
          libc         = last.pkgs.darwin.Libsystem;
          isClang      = true;
          cc           = last.pkgs.llvmPackages_7.clang-unwrapped;
        }; in args // (overrides args));

      cc = if last == null then "/dev/null" else mkCC ({ cc, ... }: {
        extraPackages = [
          last.pkgs.llvmPackages_7.libcxxabi
          last.pkgs.llvmPackages_7.compiler-rt
        ];
        extraBuildCommands = mkExtraBuildCommands cc;
      });

      ccNoLibcxx = if last == null then "/dev/null" else mkCC ({ cc, ... }: {
        libcxx = null;
        extraPackages = [
          last.pkgs.llvmPackages_7.compiler-rt
        ];
        extraBuildCommands = ''
          echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
          echo "-B${last.pkgs.llvmPackages_7.compiler-rt}/lib" >> $out/nix-support/cc-cflags
          echo "-nostdlib++" >> $out/nix-support/cc-cflags
        '' + mkExtraBuildCommands cc;
      });

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

        overrides  = self: super: (overrides self super) // {
          inherit ccNoLibcxx;
          fetchurl = thisStdenv.fetchurlBoot;
        };
      };

    in {
      inherit config overlays;
      stdenv = thisStdenv;
    };

  stage0 = stageFun 0 null {
    overrides = self: super: with stage0; {
      coreutils = stdenv.mkDerivation {
        name = "bootstrap-stage0-coreutils";
        buildCommand = ''
          mkdir -p $out
          ln -s ${bootstrapTools}/bin $out/bin
        '';
      };

      gnugrep = stdenv.mkDerivation {
        name = "bootstrap-stage0-gnugrep";
        buildCommand = ''
          mkdir -p $out
          ln -s ${bootstrapTools}/bin $out/bin
        '';
      };

      darwin = super.darwin // {
        Libsystem = stdenv.mkDerivation {
          name = "bootstrap-stage0-Libsystem";
          buildCommand = ''
            mkdir -p $out

            cp -r ${self.darwin.darwin-stubs}/usr/lib $out/lib
            chmod -R +w $out/lib
            substituteInPlace $out/lib/libSystem.B.tbd --replace /usr/lib/system $out/lib/system

            ln -s libSystem.B.tbd $out/lib/libSystem.tbd

            for name in c dbm dl info m mx poll proc pthread rpcsvc util gcc_s.10.4 gcc_s.10.5; do
              ln -s libSystem.tbd $out/lib/lib$name.tbd
            done

            ln -s ${bootstrapTools}/lib/*.o $out/lib

            ln -s ${bootstrapTools}/lib/libresolv.9.dylib $out/lib
            ln -s libresolv.9.dylib $out/lib/libresolv.dylib

            ln -s ${bootstrapTools}/include-Libsystem $out/include
          '';
        };

        darwin-stubs = super.darwin.darwin-stubs.override { inherit (self) stdenv fetchurl; };

        dyld = {
          name = "bootstrap-stage0-dyld";
          buildCommand = ''
            mkdir -p $out
            ln -s ${bootstrapTools}/lib     $out/lib
            ln -s ${bootstrapTools}/include $out/include
          '';
        };

        binutils = lib.makeOverridable (import ../../build-support/bintools-wrapper) {
          shell = "${bootstrapTools}/bin/bash";
          inherit lib;
          inherit (self) stdenvNoCC;

          nativeTools  = false;
          nativeLibc   = false;
          inherit (self) buildPackages coreutils gnugrep;
          libc         = self.pkgs.darwin.Libsystem;
          bintools     = { name = "bootstrap-stage0-binutils"; outPath = bootstrapTools; };
        };
      };

      llvmPackages_7 = {
        clang-unwrapped = stdenv.mkDerivation {
          name = "bootstrap-stage0-clang";
          version = bootstrapClangVersion;
          buildCommand = ''
            mkdir -p $out/lib
            ln -s ${bootstrapTools}/bin $out/bin
            ln -s ${bootstrapTools}/lib/clang $out/lib/clang
            ln -s ${bootstrapTools}/include $out/include
          '';
        };

        libcxx = stdenv.mkDerivation {
          name = "bootstrap-stage0-libcxx";
          phases = [ "installPhase" "fixupPhase" ];
          installPhase = ''
            mkdir -p $out/lib $out/include
            ln -s ${bootstrapTools}/lib/libc++.dylib $out/lib/libc++.dylib
            ln -s ${bootstrapTools}/include/c++      $out/include/c++
          '';
          passthru = {
            isLLVM = true;
          };
        };

        libcxxabi = stdenv.mkDerivation {
          name = "bootstrap-stage0-libcxxabi";
          buildCommand = ''
            mkdir -p $out/lib
            ln -s ${bootstrapTools}/lib/libc++abi.dylib $out/lib/libc++abi.dylib
          '';
        };

        compiler-rt = stdenv.mkDerivation {
          name = "bootstrap-stage0-compiler-rt";
          buildCommand = ''
            mkdir -p $out/lib
            ln -s ${bootstrapTools}/lib/libclang_rt* $out/lib
            ln -s ${bootstrapTools}/lib/darwin       $out/lib/darwin
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
      cmake = super.cmakeMinimal;

      python3 = super.python3Minimal;

      ninja = super.ninja.override { buildDocs = false; };

      llvmPackages_7 = super.llvmPackages_7 // (let
        tools = super.llvmPackages_7.tools.extend (_: _: {
          inherit (llvmPackages_7) clang-unwrapped;
        });
        libraries = super.llvmPackages_7.libraries.extend (_: _: {
          inherit (llvmPackages_7) compiler-rt libcxx libcxxabi;
        });
      in { inherit tools libraries; } // tools // libraries);

      darwin = super.darwin // {
        binutils = darwin.binutils.override {
          coreutils = self.coreutils;
          libc = self.darwin.Libsystem;
        };
      };
    };
  in with prevStage; stageFun 1 prevStage {
    extraPreHook = "export NIX_CFLAGS_COMPILE+=\" -F${bootstrapTools}/Library/Frameworks\"";
    extraNativeBuildInputs = [];
    extraBuildInputs = [ ];
    libcxx = pkgs.libcxx;

    allowedRequisites =
      [ bootstrapTools ] ++
      (with pkgs; [ coreutils gnugrep libcxx libcxxabi llvmPackages_7.clang-unwrapped llvmPackages_7.compiler-rt ]) ++
      (with pkgs.darwin; [ darwin-stubs Libsystem ]);

    overrides = persistent;
  };

  stage2 = prevStage: let
    persistent = self: super: with prevStage; {
      inherit
        zlib patchutils m4 scons flex perl bison unifdef unzip openssl python3
        libxml2 gettext sharutils gmp libarchive ncurses pkg-config libedit groff
        openssh sqlite sed serf openldap db cyrus-sasl expat apr-util subversion xz
        findfreetype libssh curl cmake autoconf automake libtool ed cpio coreutils
        libssh2 nghttp2 libkrb5 ninja brotli;

      llvmPackages_7 = super.llvmPackages_7 // (let
        tools = super.llvmPackages_7.tools.extend (_: _: {
          inherit (llvmPackages_7) clang-unwrapped;
        });
        libraries = super.llvmPackages_7.libraries.extend (_: libSuper: {
          inherit (llvmPackages_7) compiler-rt;
          libcxx = libSuper.libcxx.override {
            stdenv = overrideCC self.stdenv self.ccNoLibcxx;
          };
          libcxxabi = libSuper.libcxxabi.override {
            stdenv = overrideCC self.stdenv self.ccNoLibcxx;
            standalone = true;
          };
        });
      in { inherit tools libraries; } // tools // libraries);

      darwin = super.darwin // {
        inherit (darwin)
          binutils dyld Libsystem xnu configd ICU libdispatch libclosure
          launchd CF darwin-stubs;
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
      (with pkgs; [
        xz.bin xz.out libcxx libcxxabi llvmPackages_7.compiler-rt
        llvmPackages_7.clang-unwrapped zlib libxml2.out curl.out brotli.lib openssl.out
        libssh2.out nghttp2.lib libkrb5 coreutils gnugrep pcre.out gmp libiconv
      ]) ++
      (with pkgs.darwin; [ dyld Libsystem CF ICU locale ]);

    overrides = persistent;
  };

  stage3 = prevStage: let
    persistent = self: super: with prevStage; {
      inherit
        patchutils m4 scons flex perl bison unifdef unzip openssl python3
        gettext sharutils libarchive pkg-config groff bash subversion
        openssh sqlite sed serf openldap db cyrus-sasl expat apr-util
        findfreetype libssh curl cmake autoconf automake libtool cpio
        libssh2 nghttp2 libkrb5 ninja;

      # Avoid pulling in a full python and its extra dependencies for the llvm/clang builds.
      libxml2 = super.libxml2.override { pythonSupport = false; };

      llvmPackages_7 = super.llvmPackages_7 // (let
        libraries = super.llvmPackages_7.libraries.extend (_: _: {
          inherit (llvmPackages_7) libcxx libcxxabi;
        });
      in { inherit libraries; } // libraries);

      darwin = super.darwin // {
        inherit (darwin)
          dyld Libsystem xnu configd libdispatch libclosure launchd libiconv
          locale darwin-stubs;
      };
    };
  in with prevStage; stageFun 3 prevStage {
    shell = "${pkgs.bash}/bin/bash";

    # We have a valid shell here (this one has no bootstrap-tools runtime deps) so stageFun
    # enables patchShebangs above. Unfortunately, patchShebangs ignores our $SHELL setting
    # and instead goes by $PATH, which happens to contain bootstrapTools. So it goes and
    # patches our shebangs back to point at bootstrapTools. This makes sure bash comes first.
    extraNativeBuildInputs = with pkgs; [ xz ];
    extraBuildInputs = [ pkgs.darwin.CF pkgs.bash ];
    libcxx = pkgs.libcxx;

    extraPreHook = ''
      export PATH=${pkgs.bash}/bin:$PATH
      export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
    '';

    allowedRequisites =
      [ bootstrapTools ] ++
      (with pkgs; [
        xz.bin xz.out bash libcxx libcxxabi llvmPackages_7.compiler-rt
        llvmPackages_7.clang-unwrapped zlib libxml2.out curl.out brotli.lib openssl.out
        libssh2.out nghttp2.lib libkrb5 coreutils gnugrep pcre.out gmp libiconv
      ]) ++
      (with pkgs.darwin; [ dyld ICU Libsystem locale ]);

    overrides = persistent;
  };

  stage4 = prevStage: let
    persistent = self: super: with prevStage; {
      inherit
        gnumake gzip gnused bzip2 gawk ed xz patch bash python3
        ncurses libffi zlib gmp pcre gnugrep cmake
        coreutils findutils diffutils patchutils ninja libxml2;

      # Hack to make sure we don't link ncurses in bootstrap tools. The proper
      # solution is to avoid passing -L/nix-store/...-bootstrap-tools/lib,
      # quite a sledgehammer just to get the C runtime.
      gettext = super.gettext.overrideAttrs (drv: {
        configureFlags = drv.configureFlags ++ [
          "--disable-curses"
        ];
      });

      llvmPackages_7 = super.llvmPackages_7 // (let
        tools = super.llvmPackages_7.tools.extend (llvmSelf: _: {
          clang-unwrapped = llvmPackages_7.clang-unwrapped.override { llvm = llvmSelf.llvm; };
          llvm = llvmPackages_7.llvm.override { inherit libxml2; };
        });
        libraries = super.llvmPackages_7.libraries.extend (llvmSelf: _: {
          inherit (llvmPackages_7) libcxx libcxxabi compiler-rt;
        });
      in { inherit tools libraries; } // tools // libraries);

      darwin = super.darwin // rec {
        inherit (darwin) dyld Libsystem libiconv locale darwin-stubs;

        CF = super.darwin.CF.override {
          inherit libxml2;
          python3 = prevStage.python3;
        };
      };
    };
  in with prevStage; stageFun 4 prevStage {
    shell = "${pkgs.bash}/bin/bash";
    extraNativeBuildInputs = with pkgs; [ xz ];
    extraBuildInputs = [ pkgs.darwin.CF pkgs.bash ];
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

      llvmPackages_7 = super.llvmPackages_7 // (let
        tools = super.llvmPackages_7.tools.extend (_: super: {
          inherit (llvmPackages_7) llvm clang-unwrapped;
        });
        libraries = super.llvmPackages_7.libraries.extend (_: _: {
          inherit (llvmPackages_7) compiler-rt libcxx libcxxabi;
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
      libc = pkgs.darwin.Libsystem;
      shellPackage = pkgs.bash;
      inherit bootstrapTools;
    };

    allowedRequisites = (with pkgs; [
      xz.out xz.bin libcxx libcxxabi gmp.out gnumake findutils bzip2.out
      bzip2.bin llvmPackages.llvm llvmPackages.llvm.lib llvmPackages.compiler-rt llvmPackages.compiler-rt.dev
      zlib.out zlib.dev libffi.out coreutils ed diffutils gnutar
      gzip ncurses.out ncurses.dev ncurses.man gnused bash gawk
      gnugrep llvmPackages.clang-unwrapped llvmPackages.clang-unwrapped.lib patch pcre.out gettext
      binutils.bintools darwin.binutils darwin.binutils.bintools
      curl.out brotli.lib openssl.out libssh2.out nghttp2.lib libkrb5
      cc.expand-response-params libxml2.out
    ]) ++ (with pkgs.darwin; [
      dyld Libsystem CF cctools ICU libiconv locale libtapi
    ]);

    overrides = lib.composeExtensions persistent (self: super: {
      clang = cc;
      llvmPackages = super.llvmPackages // { clang = cc; };
      inherit cc;

      darwin = super.darwin // {
        inherit (prevStage.darwin) CF darwin-stubs;
        xnu = super.darwin.xnu.override { inherit (prevStage) python3; };
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
