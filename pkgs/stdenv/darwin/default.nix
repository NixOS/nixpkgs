{ lib
, localSystem
, crossSystem
, config
, overlays
, crossOverlays ? [ ]
, bootstrapLlvmVersion ? "11.1.0"
  # Allow passing in bootstrap files directly so we can test the stdenv bootstrap process when changing the bootstrap tools
, bootstrapFiles ? if localSystem.isAarch64 then
    let
      fetch = { file, sha256, executable ? true }: import <nix/fetchurl.nix> {
        url = "http://tarballs.nixos.org/stdenv-darwin/aarch64/20acd4c4f14040485f40e55c0a76c186aa8ca4f3/${file}";
        inherit (localSystem) system;
        inherit sha256 executable;
      }; in
    {
      sh = fetch { file = "sh"; sha256 = "17m3xrlbl99j3vm7rzz3ghb47094dyddrbvs2a6jalczvmx7spnj"; };
      bzip2 = fetch { file = "bzip2"; sha256 = "1khs8s5klf76plhlvlc1ma838r8pc1qigk9f5bdycwgbn0nx240q"; };
      mkdir = fetch { file = "mkdir"; sha256 = "1m9nk90paazl93v43myv2ay68c1arz39pqr7lk5ddbgb177hgg8a"; };
      cpio = fetch { file = "cpio"; sha256 = "17pxq61yjjvyd738fy9f392hc9cfzkl612sdr9rxr3v0dgvm8y09"; };
      tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "1v2332k33akm6mrm4bj749rxnnmc2pkbgcslmd0bbkf76bz2ildy"; executable = false; };
    }
  else
    let
      fetch = { file, sha256, executable ? true }: import <nix/fetchurl.nix> {
        url = "http://tarballs.nixos.org/stdenv-darwin/x86_64/c253216595572930316f2be737dc288a1da22558/${file}";
        inherit (localSystem) system;
        inherit sha256 executable;
      }; in
    {
      sh = fetch { file = "sh"; sha256 = "sha256-igMAVEfumFv/LUNTGfNi2nSehgTNIP4Sg+f3L7u6SMA="; };
      bzip2 = fetch { file = "bzip2"; sha256 = "sha256-K3rhkJZipudT1Jgh+l41Y/fNsMkrPtiAsNRDha/lpZI="; };
      mkdir = fetch { file = "mkdir"; sha256 = "sha256-VddFELwLDJGNADKB1fWwWPBtIAlEUgJv2hXRmC4NEeM="; };
      cpio = fetch { file = "cpio"; sha256 = "sha256-SWkwvLaFyV44kLKL2nx720SvcL4ej/p2V/bX3uqAGO0="; };
      tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "sha256-kRC/bhCmlD4L7KAvJQgcukk7AinkMz4IwmG1rqlh5tA="; executable = false; };
    }
}:

assert crossSystem == localSystem;

let
  inherit (localSystem) system;

  useAppleSDKLibs = localSystem.isAarch64;
  haveKRB5 = localSystem.isx86_64;

  # final toolchain is injected into llvmPackages_${finalLlvmVersion}
  finalLlvmVersion = lib.versions.major bootstrapLlvmVersion;
  finalLlvmPackages = "llvmPackages_${finalLlvmVersion}";

  commonImpureHostDeps = [
    "/bin/sh"
    "/usr/lib/libSystem.B.dylib"
    "/usr/lib/system/libunc.dylib" # This dependency is "hidden", so our scanning code doesn't pick it up
  ];

in
rec {
  commonPreHook = ''
    export NIX_ENFORCE_NO_NATIVE=''${NIX_ENFORCE_NO_NATIVE-1}
    export NIX_ENFORCE_PURITY=''${NIX_ENFORCE_PURITY-1}
    export NIX_IGNORE_LD_THROUGH_GCC=1
    unset SDKROOT

    stripAllFlags=" " # the Darwin "strip" command doesn't know "-s"
  '';

  bootstrapTools = derivation ({
    inherit system;

    name = "bootstrap-tools";
    builder = bootstrapFiles.sh; # Not a filename! Attribute 'sh' on bootstrapFiles
    args = if localSystem.isAarch64 then [ ./unpack-bootstrap-tools-aarch64.sh ] else [ ./unpack-bootstrap-tools.sh ];

    inherit (bootstrapFiles) mkdir bzip2 cpio tarball;

    __impureHostDeps = commonImpureHostDeps;
  } // lib.optionalAttrs config.contentAddressedByDefault {
    __contentAddressed = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  });

  stageFun = step: last: { shell ? "${bootstrapTools}/bin/bash"
                         , overrides ? (self: super: { })
                         , extraPreHook ? ""
                         , extraNativeBuildInputs
                         , extraBuildInputs
                         , libcxx
                         , allowedRequisites ? null
                         }:
    let
      name = "bootstrap-stage${toString step}";

      buildPackages = lib.optionalAttrs (last ? stdenv) {
        inherit (last) stdenv;
      };

      doSign = localSystem.isAarch64 && last != null;
      doUpdateAutoTools = localSystem.isAarch64 && last != null;
      inherit (last.pkgs) runCommandLocal;

      mkExtraBuildCommands = cc: ''
        rsrc="$out/resource-root"
        mkdir "$rsrc"
        ln -s "${cc.lib or cc}/lib/clang/${cc.version}/include" "$rsrc"
        ln -s "${last.pkgs."${finalLlvmPackages}".compiler-rt.out}/lib" "$rsrc/lib"
        echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
      '';

      mkCC = overrides: import ../../build-support/cc-wrapper (
        let args = {
          inherit lib shell;
          inherit (last) stdenvNoCC;

          nativeTools = false;
          nativeLibc = false;
          inherit buildPackages libcxx;
          inherit (last.pkgs) coreutils gnugrep;
          bintools = last.pkgs.darwin.binutils;
          libc = last.pkgs.darwin.Libsystem;
          isClang = true;
          cc = last.pkgs."${finalLlvmPackages}".clang-unwrapped;
        }; in args // (overrides args)
      );

      cc = if last == null then "/dev/null" else
      mkCC ({ cc, ... }: {
        extraPackages = [
          last.pkgs."${finalLlvmPackages}".libcxxabi
          last.pkgs."${finalLlvmPackages}".compiler-rt
        ];
        extraBuildCommands = mkExtraBuildCommands cc;
      });

      ccNoLibcxx = if last == null then "/dev/null" else
      mkCC ({ cc, ... }: {
        libcxx = null;
        extraPackages = [
          last.pkgs."${finalLlvmPackages}".compiler-rt
        ];
        extraBuildCommands = ''
          echo "-rtlib=compiler-rt" >> $out/nix-support/cc-cflags
          echo "-B${last.pkgs."${finalLlvmPackages}".compiler-rt}/lib" >> $out/nix-support/cc-cflags
          echo "-nostdlib++" >> $out/nix-support/cc-cflags
        '' + mkExtraBuildCommands cc;
      });

      thisStdenv = import ../generic {
        name = "${name}-stdenv-darwin";

        inherit config shell extraBuildInputs;

        extraNativeBuildInputs = extraNativeBuildInputs ++ lib.optionals doUpdateAutoTools [
          last.pkgs.updateAutotoolsGnuConfigScriptsHook
          last.pkgs.gnu-config
        ];

        allowedRequisites = if allowedRequisites == null then null else allowedRequisites ++ [
          cc.expand-response-params
          cc.bintools
        ] ++ lib.optionals doUpdateAutoTools [
          last.pkgs.updateAutotoolsGnuConfigScriptsHook
          last.pkgs.gnu-config
        ] ++ lib.optionals doSign [
          last.pkgs.darwin.postLinkSignHook
          last.pkgs.darwin.sigtool
          last.pkgs.darwin.signingUtils
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
        initialPath = [ bootstrapTools ];

        fetchurlBoot = import ../../build-support/fetchurl {
          inherit lib;
          stdenvNoCC = stage0.stdenv;
          curl = bootstrapTools;
        };

        # The stdenvs themselves don't use mkDerivation, so I need to specify this here
        __stdenvImpureHostDeps = commonImpureHostDeps;
        __extraImpureHostDeps = commonImpureHostDeps;

        overrides = self: super: (overrides self super) // {
          inherit ccNoLibcxx;
          fetchurl = thisStdenv.fetchurlBoot;
        };
      };

    in
    {
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

      pbzx = self.runCommandLocal "bootstrap-stage0-pbzx" { } ''
        mkdir -p $out/bin
        ln -s ${bootstrapTools}/bin/pbzx $out/bin
      '';

      cpio = self.runCommandLocal "bootstrap-stage0-cpio" { } ''
        mkdir -p $out/bin
        ln -s ${bootstrapFiles.cpio} $out/bin/cpio
      '';

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        darwin-stubs = superDarwin.darwin-stubs.override { inherit (self) stdenvNoCC fetchurl; };

        dyld = {
          name = "bootstrap-stage0-dyld";
          buildCommand = ''
            mkdir -p $out
            ln -s ${bootstrapTools}/lib     $out/lib
            ln -s ${bootstrapTools}/include $out/include
          '';
        };

        sigtool = self.runCommandLocal "bootstrap-stage0-sigtool" { } ''
           mkdir -p $out/bin
           ln -s ${bootstrapTools}/bin/sigtool  $out/bin
           ln -s ${bootstrapTools}/bin/codesign $out/bin
        '';

        print-reexports = self.runCommandLocal "bootstrap-stage0-print-reexports" { } ''
          mkdir -p $out/bin
          ln -s ${bootstrapTools}/bin/print-reexports $out/bin
        '';

        rewrite-tbd = self.runCommandLocal "bootstrap-stage0-rewrite-tbd" { } ''
          mkdir -p $out/bin
          ln -s ${bootstrapTools}/bin/rewrite-tbd $out/bin
        '';

        binutils-unwrapped = { name = "bootstrap-stage0-binutils"; outPath = bootstrapTools; };

        cctools = {
          name = "bootstrap-stage0-cctools";
          outPath = bootstrapTools;
          targetPrefix = "";
        };

        binutils = lib.makeOverridable (import ../../build-support/bintools-wrapper) {
          shell = "${bootstrapTools}/bin/bash";
          inherit lib;
          inherit (self) stdenvNoCC;

          nativeTools = false;
          nativeLibc = false;
          inherit (self) buildPackages coreutils gnugrep;
          libc = selfDarwin.Libsystem;
          bintools = selfDarwin.binutils-unwrapped;
          inherit (selfDarwin) postLinkSignHook signingUtils;
        };
      } // lib.optionalAttrs (! useAppleSDKLibs) {
        CF = stdenv.mkDerivation {
          name = "bootstrap-stage0-CF";
          buildCommand = ''
            mkdir -p $out/Library/Frameworks
            ln -s ${bootstrapTools}/Library/Frameworks/CoreFoundation.framework $out/Library/Frameworks
          '';
        };

        Libsystem = stdenv.mkDerivation {
          name = "bootstrap-stage0-Libsystem";
          buildCommand = ''
            mkdir -p $out

            cp -r ${selfDarwin.darwin-stubs}/usr/lib $out/lib
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
      });

      "${finalLlvmPackages}" = {
        clang-unwrapped = stdenv.mkDerivation {
          name = "bootstrap-stage0-clang";
          version = bootstrapLlvmVersion;
          buildCommand = ''
            mkdir -p $out/lib
            ln -s ${bootstrapTools}/bin $out/bin
            ln -s ${bootstrapTools}/lib/clang $out/lib/clang
            ln -s ${bootstrapTools}/include $out/include
          '';
        };

        libcxx = stdenv.mkDerivation {
          name = "bootstrap-stage0-libcxx";
          dontUnpack = true;
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

    extraNativeBuildInputs = [ ];
    extraBuildInputs = [ ];
    libcxx = null;
  };

  stage1 = prevStage:
    let
      persistent = self: super: with prevStage; {
        cmake = super.cmakeMinimal;

        curl = super.curlMinimal;

        inherit pbzx cpio;

        python3 = super.python3Minimal;

        ninja = super.ninja.override { buildDocs = false; };

        "${finalLlvmPackages}" = super."${finalLlvmPackages}" // (
          let
            tools = super."${finalLlvmPackages}".tools.extend (_: _: {
              inherit (pkgs."${finalLlvmPackages}") clang-unwrapped;
            });
            libraries = super."${finalLlvmPackages}".libraries.extend (_: _: {
              inherit (pkgs."${finalLlvmPackages}") compiler-rt libcxx libcxxabi;
            });
          in
          { inherit tools libraries; } // tools // libraries
        );

        darwin = super.darwin.overrideScope (selfDarwin: _: {
          inherit (darwin) rewrite-tbd binutils-unwrapped;

          signingUtils = darwin.signingUtils.override {
            inherit (selfDarwin) sigtool;
          };

          binutils = darwin.binutils.override {
            coreutils = self.coreutils;
            libc = selfDarwin.Libsystem;
            inherit (selfDarwin) postLinkSignHook signingUtils;
          };
        });
      };
    in
    with prevStage; stageFun 1 prevStage {
      extraPreHook = "export NIX_CFLAGS_COMPILE+=\" -F${bootstrapTools}/Library/Frameworks\"";
      extraNativeBuildInputs = [ ];
      extraBuildInputs = [ pkgs.darwin.CF ];
      libcxx = pkgs."${finalLlvmPackages}".libcxx;

      allowedRequisites =
        [ bootstrapTools ] ++
        (with pkgs; [ coreutils gnugrep ]) ++
        (with pkgs."${finalLlvmPackages}"; [ libcxx libcxxabi compiler-rt clang-unwrapped ]) ++
        (with pkgs.darwin; [ Libsystem CF ] ++ lib.optional useAppleSDKLibs objc4);

      overrides = persistent;
    };

  stage2 = prevStage:
    let
      persistent = self: super: with prevStage; {
        inherit
          zlib patchutils m4 scons flex perl bison unifdef unzip openssl python3
          libxml2 gettext sharutils gmp libarchive ncurses pkg-config libedit groff
          openssh sqlite sed serf openldap db cyrus-sasl expat apr-util subversion xz
          findfreetype libssh curl cmake autoconf automake libtool ed cpio coreutils
          libssh2 nghttp2 libkrb5 ninja brotli libiconv;

        "${finalLlvmPackages}" = super."${finalLlvmPackages}" // (
          let
            tools = super."${finalLlvmPackages}".tools.extend (_: _: {
              inherit (pkgs."${finalLlvmPackages}") clang-unwrapped;
            });
            libraries = super."${finalLlvmPackages}".libraries.extend (_: libSuper: {
              inherit (pkgs."${finalLlvmPackages}") compiler-rt;
              libcxx = libSuper.libcxx.override {
                stdenv = overrideCC self.stdenv self.ccNoLibcxx;
              };
              libcxxabi = libSuper.libcxxabi.override ({
                stdenv = overrideCC self.stdenv self.ccNoLibcxx;
              } // lib.optionalAttrs (builtins.any (v: finalLlvmVersion == v) [ 7 11 12 13 ]) {
                # TODO: the bootstrapping of llvm packages isn't consistent.
                # `standalone` may be redundant if darwin behaves like useLLVM (or
                # has useLLVM = true).
                standalone = true;
              });
            });
          in
          { inherit tools libraries; } // tools // libraries
        );

        darwin = super.darwin.overrideScope (_: _: {
          inherit (darwin)
            binutils dyld Libsystem xnu configd ICU libdispatch libclosure
            launchd CF objc4 darwin-stubs sigtool postLinkSignHook signingUtils;
        });
      };
    in
    with prevStage; stageFun 2 prevStage {
      extraPreHook = ''
        export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
      '';

      extraNativeBuildInputs = [ pkgs.xz ];
      extraBuildInputs = [ pkgs.darwin.CF ];
      libcxx = pkgs."${finalLlvmPackages}".libcxx;

      allowedRequisites =
        [ bootstrapTools ] ++
        (with pkgs; [
          xz.bin
          xz.out
          zlib
          libxml2.out
          curl.out
          openssl.out
          libssh2.out
          nghttp2.lib
          coreutils
          gnugrep
          pcre.out
          gmp
          libiconv
          brotli.lib
          file
        ] ++ lib.optional haveKRB5 libkrb5) ++
        (with pkgs."${finalLlvmPackages}"; [
          libcxx
          libcxxabi
          compiler-rt
          clang-unwrapped
        ]) ++
        (with pkgs.darwin; [ dyld Libsystem CF ICU locale ] ++ lib.optional useAppleSDKLibs objc4);

      overrides = persistent;
    };

  stage3 = prevStage:
    let
      persistent = self: super: with prevStage; {
        inherit
          patchutils m4 scons flex perl bison unifdef unzip openssl python3
          gettext sharutils libarchive pkg-config groff bash subversion
          openssh sqlite sed serf openldap db cyrus-sasl expat apr-util
          findfreetype libssh curl cmake autoconf automake libtool cpio
          libssh2 nghttp2 libkrb5 ninja;

        # Avoid pulling in a full python and its extra dependencies for the llvm/clang builds.
        libxml2 = super.libxml2.override { pythonSupport = false; };

        "${finalLlvmPackages}" = super."${finalLlvmPackages}" // (
          let
            libraries = super."${finalLlvmPackages}".libraries.extend (_: _: {
              inherit (pkgs."${finalLlvmPackages}") libcxx libcxxabi;
            });
          in
          { inherit libraries; } // libraries
        );

        darwin = super.darwin.overrideScope (_: _: {
          inherit (darwin)
            dyld Libsystem xnu configd libdispatch libclosure launchd libiconv
            locale darwin-stubs sigtool;
        });
      };
    in
    with prevStage; stageFun 3 prevStage {
      shell = "${pkgs.bash}/bin/bash";

      # We have a valid shell here (this one has no bootstrap-tools runtime deps) so stageFun
      # enables patchShebangs above. Unfortunately, patchShebangs ignores our $SHELL setting
      # and instead goes by $PATH, which happens to contain bootstrapTools. So it goes and
      # patches our shebangs back to point at bootstrapTools. This makes sure bash comes first.
      extraNativeBuildInputs = with pkgs; [ xz ];
      extraBuildInputs = [ pkgs.darwin.CF pkgs.bash ];
      libcxx = pkgs."${finalLlvmPackages}".libcxx;

      extraPreHook = ''
        export PATH=${pkgs.bash}/bin:$PATH
        export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
      '';

      allowedRequisites =
        [ bootstrapTools ] ++
        (with pkgs; [
          xz.bin
          xz.out
          bash
          zlib
          libxml2.out
          curl.out
          openssl.out
          libssh2.out
          nghttp2.lib
          coreutils
          gnugrep
          pcre.out
          gmp
          libiconv
          brotli.lib
          file
        ] ++ lib.optional haveKRB5 libkrb5) ++
        (with pkgs."${finalLlvmPackages}"; [
          libcxx
          libcxx.dev
          libcxxabi
          libcxxabi.dev
          compiler-rt
          clang-unwrapped
        ]) ++
        (with pkgs.darwin; [ dyld ICU Libsystem locale ] ++ lib.optional useAppleSDKLibs objc4);

      overrides = persistent;
    };

  stage4 = prevStage:
    let
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

        "${finalLlvmPackages}" = super."${finalLlvmPackages}" // (
          let
            tools = super."${finalLlvmPackages}".tools.extend (llvmSelf: _: {
              clang-unwrapped-all-outputs = pkgs."${finalLlvmPackages}".clang-unwrapped-all-outputs.override { llvm = llvmSelf.llvm; };
              libllvm = pkgs."${finalLlvmPackages}".libllvm.override { inherit libxml2; };
            });
            libraries = super."${finalLlvmPackages}".libraries.extend (llvmSelf: _: {
              inherit (pkgs."${finalLlvmPackages}") libcxx libcxxabi compiler-rt;
            });
          in
          { inherit tools libraries; } // tools // libraries
        );

        darwin = super.darwin.overrideScope (_: superDarwin: {
          inherit (darwin) dyld Libsystem libiconv locale darwin-stubs;

          # See useAppleSDKLibs in darwin-packages.nix
          CF = if useAppleSDKLibs then super.darwin.CF else
          superDarwin.CF.override {
            inherit libxml2;
            python3 = prevStage.python3;
          };
        });
      };
    in
    with prevStage; stageFun 4 prevStage {
      shell = "${pkgs.bash}/bin/bash";
      extraNativeBuildInputs = with pkgs; [ xz ];
      extraBuildInputs = [ pkgs.darwin.CF pkgs.bash ];
      libcxx = pkgs."${finalLlvmPackages}".libcxx;

      extraPreHook = ''
        export PATH_LOCALE=${pkgs.darwin.locale}/share/locale
      '';
      overrides = persistent;
    };

  stdenvDarwin = prevStage:
    let
      doSign = localSystem.isAarch64;
      pkgs = prevStage;
      persistent = self: super: with prevStage; {
        inherit
          gnumake gzip gnused bzip2 gawk ed xz patch bash
          ncurses libffi zlib gmp pcre gnugrep
          coreutils findutils diffutils patchutils pbzx;

        darwin = super.darwin.overrideScope (_: _: {
          inherit (darwin) dyld ICU Libsystem Csu libiconv rewrite-tbd;
        } // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
          inherit (darwin) binutils binutils-unwrapped cctools;
        });
      } // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
        inherit llvm;

        # Need to get rid of these when cross-compiling.
        "${finalLlvmPackages}" = super."${finalLlvmPackages}" // (
          let
            tools = super."${finalLlvmPackages}".tools.extend (_: super: {
              inherit (pkgs."${finalLlvmPackages}") llvm clang-unwrapped;
            });
            libraries = super."${finalLlvmPackages}".libraries.extend (_: _: {
              inherit (pkgs."${finalLlvmPackages}") compiler-rt libcxx libcxxabi;
            });
          in
          { inherit tools libraries; } // tools // libraries
        );

        inherit binutils binutils-unwrapped;
      };
    in
    import ../generic rec {
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

      initialPath = import ../generic/common-path.nix { inherit pkgs; };
      shell = "${pkgs.bash}/bin/bash";

      cc = pkgs."${finalLlvmPackages}".libcxxClang;

      extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
        pkgs.updateAutotoolsGnuConfigScriptsHook
      ];

      extraBuildInputs = [ pkgs.darwin.CF ];

      extraAttrs = {
        libc = pkgs.darwin.Libsystem;
        shellPackage = pkgs.bash;
        inherit bootstrapTools;
      };

      allowedRequisites = (with pkgs; [
        xz.out
        xz.bin
        gmp.out
        gnumake
        findutils
        bzip2.out
        bzip2.bin
        zlib.out
        zlib.dev
        libffi.out
        coreutils
        ed
        diffutils
        gnutar
        gzip
        ncurses.out
        ncurses.dev
        ncurses.man
        gnused
        bash
        gawk
        gnugrep
        patch
        pcre.out
        gettext
        binutils.bintools
        darwin.binutils
        darwin.binutils.bintools
        curl.out
        zstd.out
        libidn2.out
        libunistring.out
        openssl.out
        libssh2.out
        nghttp2.lib
        brotli.lib
        cc.expand-response-params
        libxml2.out
        file
      ] ++ lib.optional haveKRB5 libkrb5
      ++ lib.optionals localSystem.isAarch64 [
        pkgs.updateAutotoolsGnuConfigScriptsHook
        pkgs.gnu-config
      ])
      ++ (with pkgs."${finalLlvmPackages}"; [
        libcxx
        libcxx.dev
        libcxxabi
        libcxxabi.dev
        llvm
        llvm.lib
        compiler-rt
        compiler-rt.dev
        clang-unwrapped
        libclang.dev
        libclang.lib
      ])
      ++ (with pkgs.darwin; [
        dyld
        Libsystem
        CF
        cctools
        ICU
        libiconv
        locale
        libtapi
      ] ++ lib.optional useAppleSDKLibs objc4
      ++ lib.optionals doSign [ postLinkSignHook sigtool signingUtils ]);

      overrides = lib.composeExtensions persistent (self: super: {
        darwin = super.darwin.overrideScope (_: superDarwin: {
          inherit (prevStage.darwin) CF darwin-stubs;
          xnu = superDarwin.xnu.override { inherit (prevStage) python3; };
        });
      } // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
        clang = cc;
        llvmPackages = super.llvmPackages // { clang = cc; };
        inherit cc;
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
