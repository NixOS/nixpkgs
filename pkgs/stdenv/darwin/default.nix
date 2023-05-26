{ lib
, localSystem
, crossSystem
, config
, overlays
, crossOverlays ? [ ]
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

  commonImpureHostDeps = [
    "/bin/sh"
    "/usr/lib/libSystem.B.dylib"
    "/usr/lib/system/libunc.dylib" # This dependency is "hidden", so our scanning code doesn't pick it up
  ];

  isFromNixpkgs = pkg: !(isFromBootstrapFiles pkg);
  isFromBootstrapFiles =
    pkg: pkg.passthru.isFromBootstrapFiles or false;
  isBuiltByNixpkgsCompiler =
    pkg: isFromNixpkgs pkg && isFromNixpkgs pkg.stdenv.cc.cc;
  isBuiltByBootstrapFilesCompiler =
    pkg: isFromNixpkgs pkg && isFromBootstrapFiles pkg.stdenv.cc.cc;

  commonPreHook = ''
    export NIX_ENFORCE_NO_NATIVE=''${NIX_ENFORCE_NO_NATIVE-1}
    export NIX_ENFORCE_PURITY=''${NIX_ENFORCE_PURITY-1}
    export NIX_IGNORE_LD_THROUGH_GCC=1
    unset SDKROOT
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
  }) // { passthru.isFromBootstrapFiles = true; };

  stageFun = prevStage:
    { name, overrides ? (self: super: { }), extraNativeBuildInputs ? [ ], extraPreHook ? "" }:

    let
      cc = if prevStage.llvmPackages.clang-unwrapped == null
           then null else
           lib.makeOverridable (import ../../build-support/cc-wrapper) {
        name = "${name}-clang-wrapper";

        nativeTools = false;
        nativeLibc = false;

        buildPackages = lib.optionalAttrs (prevStage ? stdenv) {
          inherit (prevStage) stdenv;
        };

        extraPackages = [
          prevStage.llvmPackages.libcxxabi
          prevStage.llvmPackages.compiler-rt
        ];

        extraBuildCommands =
          let
            inherit (prevStage.llvmPackages) clang-unwrapped compiler-rt release_version;
          in
          ''
            rsrc="$out/resource-root"
            mkdir "$rsrc"
            ln -s "${clang-unwrapped.lib}/lib/clang"/${release_version}/include "$rsrc"
            ln -s "${compiler-rt.out}/lib"   "$rsrc/lib"
            ln -s "${compiler-rt.out}/share" "$rsrc/share"
            echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
          '';

        cc = prevStage.llvmPackages.clang-unwrapped;
        bintools = prevStage.darwin.binutils;

        isClang = true;
        libc = prevStage.darwin.Libsystem;
        inherit (prevStage.llvmPackages) libcxx;

        inherit lib;
        inherit (prevStage) coreutils gnugrep;

        stdenvNoCC = prevStage.ccWrapperStdenv;
      };

      thisStdenv = import ../generic {
        name = "${name}-stdenv-darwin";

        buildPlatform = localSystem;
        hostPlatform = localSystem;
        targetPlatform = localSystem;

        inherit config extraNativeBuildInputs;

        extraBuildInputs = [ prevStage.darwin.CF ];

        preHook =
          ''
            # Don't patch #!/interpreter because it leads to retained
            # dependencies on the bootstrapTools in the final stdenv.
            dontPatchShebangs=1
            ${commonPreHook}
            ${extraPreHook}
          '' + lib.optionalString (prevStage.darwin ? locale) ''
            export PATH_LOCALE=${prevStage.darwin.locale}/share/locale
          '';

        shell = "${bootstrapTools}/bin/bash";
        initialPath = [ bootstrapTools ];

        fetchurlBoot = import ../../build-support/fetchurl {
          inherit lib;
          stdenvNoCC = prevStage.ccWrapperStdenv or thisStdenv;
          curl = bootstrapTools;
        };

        inherit cc;

        # The stdenvs themselves don't use mkDerivation, so I need to specify this here
        __stdenvImpureHostDeps = commonImpureHostDeps;
        __extraImpureHostDeps = commonImpureHostDeps;

        overrides = self: super: (overrides self super) // {
          fetchurl = thisStdenv.fetchurlBoot;
        };
      };

    in
    {
      inherit config overlays;
      stdenv = thisStdenv;
    };
in
  assert bootstrapTools.passthru.isFromBootstrapFiles or false;  # sanity check
[
  ({}: {
    __raw = true;

    coreutils = null;
    gnugrep = null;

    pbzx = null;
    cpio = null;

    darwin = {
      binutils = null;
      binutils-unwrapped = null;
      cctools = null;
      print-reexports = null;
      rewrite-tbd = null;
      sigtool = null;
      CF = null;
      Libsystem = null;
    };

    llvmPackages = {
      clang-unwrapped = null;
      libllvm = null;
      libcxx = null;
      libcxxabi = null;
      compiler-rt = null;
    };
  })

  # Create a stage with the bootstrap tools. This will be used to build the subsequent stages and
  # build up the standard environment.
  #
  # Note: Each stage depends only on the the packages in `prevStage`. If a package is not to be
  # rebuilt, it should be passed through by inheriting it.
  (prevStage: stageFun prevStage {
    name = "bootstrap-stage0";

    overrides = self: super: {
      # We thread stage0's stdenv through under this name so downstream stages
      # can use it for wrapping gcc too. This way, downstream stages don't need
      # to refer to this stage directly, which violates the principle that each
      # stage should only access the stage that came before it.
      ccWrapperStdenv = self.stdenv;

      coreutils = bootstrapTools;
      gnugrep = bootstrapTools;

      pbzx = bootstrapTools;
      cpio = self.stdenv.mkDerivation {
        name = "bootstrap-stage0-cpio";
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${bootstrapFiles.cpio} $out/bin/cpio
        '';
        passthru.isFromBootstrapFiles = true;
      };

      darwin = super.darwin.overrideScope (selfDarwin: _: {
        binutils-unwrapped = bootstrapTools // {
          version = "boot";
        };

        binutils = (import ../../build-support/bintools-wrapper) {
          name = "bootstrap-stage0-binutils-wrapper";

          nativeTools = false;
          nativeLibc = false;

          buildPackages = { };
          libc = selfDarwin.Libsystem;

          inherit lib;
          inherit (self) stdenvNoCC coreutils gnugrep;

          bintools = selfDarwin.binutils-unwrapped;

          inherit (selfDarwin) postLinkSignHook signingUtils;
        };

        cctools = bootstrapTools // {
          targetPrefix = "";
          version = "boot";
          man = bootstrapTools;
        };

        locale = self.stdenv.mkDerivation {
          name = "bootstrap-stage0-locale";
          buildCommand = ''
            mkdir -p $out/share/locale
          '';
        };

        print-reexports = bootstrapTools;

        rewrite-tbd = bootstrapTools;

        sigtool = bootstrapTools;
      } // lib.optionalAttrs (! useAppleSDKLibs) {
        CF = self.stdenv.mkDerivation {
          name = "bootstrap-stage0-CF";
          buildCommand = ''
            mkdir -p $out/Library/Frameworks
            ln -s ${bootstrapTools}/Library/Frameworks/CoreFoundation.framework $out/Library/Frameworks
          '';
          passthru.isFromBootstrapFiles = true;
        };

        Libsystem = self.stdenv.mkDerivation {
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
          passthru.isFromBootstrapFiles = true;
        };
      });

      llvmPackages = super.llvmPackages // (
        let
          tools = super.llvmPackages.tools.extend (selfTools: _: {
            libclang = self.stdenv.mkDerivation {
              name = "bootstrap-stage0-clang";
              version = "boot";
              outputs = [ "out" "lib" ];
              buildCommand = ''
                mkdir -p $out/lib
                ln -s $out $lib
                ln -s ${bootstrapTools}/bin       $out/bin
                ln -s ${bootstrapTools}/lib/clang $out/lib
                ln -s ${bootstrapTools}/include   $out
              '';
              passthru.isFromBootstrapFiles = true;
            };
            clang-unwrapped = selfTools.libclang;
            libllvm = self.stdenv.mkDerivation {
              name = "bootstrap-stage0-llvm";
              outputs = [ "out" "lib" ];
              buildCommand = ''
                mkdir -p $out/bin $out/lib
                ln -s $out $lib
                ln -s ${bootstrapTools}/bin/strip    $out/bin/llvm-strip
                ln -s ${bootstrapTools}/lib/libLLVM* $out/lib
              '';
              passthru.isFromBootstrapFiles = true;
            };
            llvm = selfTools.libllvm;
          });
          libraries = super.llvmPackages.libraries.extend (_: _: {
            libcxx = self.stdenv.mkDerivation {
              name = "bootstrap-stage0-libcxx";
              buildCommand = ''
                mkdir -p $out/lib $out/include
                ln -s ${bootstrapTools}/lib/libc++.dylib $out/lib
                ln -s ${bootstrapTools}/include/c++      $out/include
              '';
              passthru = {
                isLLVM = true;
                cxxabi = self.llvmPackages.libcxxabi;
                isFromBootstrapFiles = true;
              };
            };
            libcxxabi = self.stdenv.mkDerivation {
              name = "bootstrap-stage0-libcxxabi";
              buildCommand = ''
                mkdir -p $out/lib
                ln -s ${bootstrapTools}/lib/libc++abi.dylib $out/lib
              '';
              passthru = {
                libName = "c++abi";
                isFromBootstrapFiles = true;
              };
            };
            compiler-rt = self.stdenv.mkDerivation {
              name = "bootstrap-stage0-compiler-rt";
              buildCommand = ''
                mkdir -p $out/lib $out/share
                ln -s ${bootstrapTools}/lib/libclang_rt* $out/lib
                ln -s ${bootstrapTools}/lib/darwin       $out/lib
              '';
              passthru.isFromBootstrapFiles = true;
            };
          });
        in
        # Define `release_version` as a `*`, so it’s interpreted as a glob. This is necessary
        # because the version of clang in the bootstrap tools is not known ahead of time. This
        # should be safe because the bootstrap tools should never contain multiple clangs.
        { inherit tools libraries; release_version = "*"; } // tools // libraries
      );
    };

    # The bootstrap tools may use `strip` from cctools, so use a compatible set of flags until LLVM
    # is rebuilt, and darwin.binutils can use its implementation instead.
    extraPreHook = ''
      stripAllFlags=" "    # the cctools "strip" command doesn't know "-s"
      stripDebugFlags="-S" # the cctools "strip" command does something odd with "-p"
    '';
  })

  # This stage is primarily responsible for building the linker and setting up versions of
  # certain dependencies needed by the rest of the build process. It is necessary to rebuild the
  # linker because the `compiler-rt` build process checks the version and attempts to manually
  # run `codesign` if it detects a version of `ld64` it considers too old. If that happens, the
  # build process will fail for a few different reasons:
  #  - sigtool is too old and does not accept the `--sign` argument;
  #  - sigtool is new enough to accept the `--sign` argument, but it aborts when it is invoked on a
  #    binary that is already signed; or
  #  - compiler-rt attempts to invoke `codesign` on x86_64-darwin, but `sigtool` is not currently
  #    part of the x86_64-darwin bootstrap tools.
  #
  # This stage also builds CF and Libsystem to simplify assertions and assumptions for later by
  # making sure both packages are present on x86_64-darwin and aarch64-darwin.
  (prevStage:
    # previous stage0 stdenv:
    assert lib.all isFromBootstrapFiles (with prevStage; [ coreutils cpio gnugrep pbzx ]);

    assert lib.all isFromBootstrapFiles (with prevStage.darwin; [
      binutils-unwrapped cctools print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isFromBootstrapFiles (with prevStage.darwin; [ CF Libsystem ]);
    assert    useAppleSDKLibs  -> lib.all        isFromNixpkgs (with prevStage.darwin; [ CF Libsystem ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd xnu ]);

    assert lib.all isFromBootstrapFiles (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx libcxxabi
    ]);

    stageFun prevStage {
    name = "bootstrap-stage1";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        coreutils gnugrep;

      cmake = super.cmakeMinimal;

      curl = super.curlMinimal;

      libffi = super.libffi.override { doCheck = false; };

      # Avoid pulling in a full python and its extra dependencies for the llvm/clang builds.
      libxml2 = super.libxml2.override { pythonSupport = false; };

      ninja = super.ninja.override { buildDocs = false; };

      python3 = super.python3Minimal;

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        signingUtils = prevStage.darwin.signingUtils.override {
          inherit (selfDarwin) sigtool;
        };

        binutils = superDarwin.binutils.override {
          inherit (self) coreutils;
          inherit (selfDarwin) postLinkSignHook signingUtils;

          bintools = selfDarwin.binutils-unwrapped;
          libc = selfDarwin.Libsystem;
        };

        binutils-unwrapped = superDarwin.binutils-unwrapped.override {
          inherit (selfDarwin) cctools;
        };

        cctools = selfDarwin.cctools-port;
      });

      llvmPackages = super.llvmPackages // (
        let
          tools = super.llvmPackages.tools.extend (_: _: {
            inherit (prevStage.llvmPackages) clang-unwrapped libclang libllvm llvm;
          });
          libraries = super.llvmPackages.libraries.extend (_: _: {
            inherit (prevStage.llvmPackages) compiler-rt libcxx libcxxabi;
          });
        in
        { inherit tools libraries; inherit (prevStage.llvmPackages) release_version; } // tools // libraries
      );
    };

    extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
      prevStage.updateAutotoolsGnuConfigScriptsHook
      prevStage.gnu-config
    ];

    # The bootstrap tools may use `strip` from cctools, so use a compatible set of flags until LLVM
    # is rebuilt, and darwin.binutils can use its implementation instead.
    extraPreHook = ''
      stripAllFlags=" "    # the cctools "strip" command doesn't know "-s"
      stripDebugFlags="-S" # the cctools "strip" command does something odd with "-p"
    '';
  })

  # Build sysctl and Python for use by LLVM’s check phase. These must be built in their own stage,
  # or an infinite recursion results on x86_64-darwin when using the source-based SDK.
  (prevStage:
    # previous stage1 stdenv:
    assert lib.all isFromBootstrapFiles (with prevStage; [ coreutils gnugrep ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bash binutils-unwrapped bison brotli cmake cpio curl cyrus_sasl db
      ed expat flex gettext gmp groff libedit libffi libiconv libidn2 libkrb5 libssh2
      libtool libunistring libxml2 m4 ncurses nghttp2 ninja openldap openssh openssl
      patchutils pbzx perl pkg-config.pkg-config python3 scons serf sqlite subversion
      sysctl.provider unzip which xz zlib zstd
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools libiconv locale libtapi print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ CF Libsystem ICU ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd xnu ]);

    assert lib.all isFromBootstrapFiles (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx libcxxabi
    ]);

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == "boot";

    stageFun prevStage {
    name = "bootstrap-stage1-sysctl";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        autoconf automake bash binutils binutils-unwrapped bison brotli cmake cpio coreutils
        curl cyrus_sasl db ed expat flex gettext gmp gnugrep groff libedit libffi libiconv
        libidn2 libkrb5 libssh2 libtool libunistring libxml2 m4 ncurses nghttp2 ninja
        openldap openssh openssl patchutils pbzx perl pkg-config scons sed serf sharutils
        sqlite subversion unzip which xz zlib zstd;

      # Support for the SystemConfiguration framework is required to run the LLVM tests, but trying
      # to override python3Minimal does not appear to work.
      python3 = (super.python3.override {
        inherit (self) libffi;
        inherit (self.darwin) configd;
        openssl = null;
        readline = null;
        ncurses = null;
        gdbm = null;
        sqlite = null;
        tzdata = null;
        stripConfig = true;
        stripIdlelib = true;
        stripTests = true;
        stripTkinter = true;
        rebuildBytecode = false;
        stripBytecode = true;
        includeSiteCustomize = false;
        enableOptimizations = false;
        enableLTO = false;
        mimetypesSupport = false;
      }).overrideAttrs (_: { pname = "python3-minimal-scproxy"; });

      darwin = super.darwin.overrideScope (_: superDarwin: {
        inherit (prevStage.darwin)
          CF Libsystem ICU configd binutils-unwrapped cctools cctools-port darwin-stubs dyld
          launchd libclosure libdispatch libobjc objc4 locale postLinkSignHook
          print-reexports rewrite-tbd signingUtils sigtool;
      });

      llvmPackages = super.llvmPackages // (
        let
          tools = super.llvmPackages.tools.extend (_: _: {
            inherit (prevStage.llvmPackages) clang-unwrapped libclang libllvm llvm;
            clang = prevStage.stdenv.cc;
          });
          libraries = super.llvmPackages.libraries.extend (_: _: {
            inherit (prevStage.llvmPackages) compiler-rt libcxx libcxxabi;
          });
        in
        { inherit tools libraries; inherit (prevStage.llvmPackages) release_version; } // tools // libraries
      );
    };

    extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
      prevStage.updateAutotoolsGnuConfigScriptsHook
      prevStage.gnu-config
    ];

    # Until LLVM is rebuilt, assume `strip` is the one from cctools.
    extraPreHook = ''
      stripAllFlags=" "    # the cctools "strip" command doesn't know "-s"
      stripDebugFlags="-S" # the cctools "strip" command does something odd with "-p"
    '';
  })

  # First rebuild of LLVM. While this LLVM is linked to a bunch of junk from the bootstrap tools,
  # the libc++ and libc++abi it produces are not. The compiler will be rebuilt in a later stage,
  # but those libraries will be used in the final stdenv.
  #
  # Rebuild coreutils and gnugrep to avoid unwanted references to the bootstrap tools on `PATH`.
  (prevStage:
    # previous stage-sysctl stdenv:
    assert lib.all isFromBootstrapFiles (with prevStage; [ coreutils gnugrep ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bash binutils-unwrapped bison brotli cmake cpio curl cyrus_sasl db
      ed expat flex gettext gmp groff libedit libffi libiconv libidn2 libkrb5 libssh2
      libtool libunistring libxml2 m4 ncurses nghttp2 ninja openldap openssh openssl
      patchutils pbzx perl pkg-config.pkg-config python3 scons serf sqlite subversion
      sysctl.provider unzip which xz zlib zstd
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools libiconv locale libtapi print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ CF Libsystem ICU ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd xnu ]);

    assert lib.all isFromBootstrapFiles (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx libcxxabi
    ]);

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == lib.getVersion prevStage.darwin.cctools-port;

    stageFun prevStage {
    name = "bootstrap-stage-xclang";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        autoconf automake bash binutils binutils-unwrapped bison brotli cmake cpio curl
        cyrus_sasl db ed expat flex gettext gmp groff libedit libffi libiconv libidn2
        libkrb5 libssh2 libtool libunistring libxml2 m4 ncurses nghttp2 ninja openldap
        openssh openssl patchutils pbzx perl pkg-config python3 scons sed serf sharutils
        sqlite subversion sysctl unzip which xz zlib zstd;

      llvmPackages = super.llvmPackages // (
        let
          llvmMajor = lib.versions.major super.llvmPackages.release_version;

          libraries = super.llvmPackages.libraries.extend (selfLib: superLib: {
            compiler-rt = superLib.compiler-rt.override ({
              inherit (selfLib) libcxxabi;
              stdenv = self.overrideCC self.stdenv (self.llvmPackages.clangNoCompilerRtWithLibc.override {
                inherit (selfLib) libcxx;
              });
            });
            libcxx = superLib.libcxx.override ({
              inherit (selfLib) libcxxabi;
              stdenv = self.overrideCC self.stdenv (self.llvmPackages.clangNoCompilerRtWithLibc.override {
                nixSupport.cc-cflags = [ "-nostdlib" ];
                nixSupport.cc-ldflags = [ "-lSystem" ];
              });
            });
            libcxxabi = superLib.libcxxabi.override ({
              stdenv = self.overrideCC self.stdenv self.llvmPackages.clangNoCompilerRtWithLibc;
            } // lib.optionalAttrs (builtins.any (v: llvmMajor == v) [ 7 11 12 13 ]) {
              # TODO: the bootstrapping of llvm packages isn't consistent.
              # `standalone` may be redundant if darwin behaves like useLLVM (or
              # has useLLVM = true).
              standalone = true;
            });
          });
        in
        { inherit libraries; } // libraries
      );

      # Switch from cctools-port to cctools-llvm now that LLVM has been built.
      darwin = super.darwin.overrideScope (_: _: {
        inherit (prevStage.darwin)
          CF Libsystem ICU configd darwin-stubs dyld launchd
          libclosure libdispatch libobjc objc4 locale postLinkSignHook print-reexports rewrite-tbd
          signingUtils sigtool;
      });
    };

    extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
      prevStage.updateAutotoolsGnuConfigScriptsHook
      prevStage.gnu-config
    ];

    extraPreHook = ''
      stripAllFlags=" "    # the cctools "strip" command doesn't know "-s"
      stripDebugFlags="-S" # the cctools "strip" command does something odd with "-p"
    '';
  })

  # This stage rebuilds Libsystem using the new compiler.
   (prevStage:
    # previous stage1 stdenv:
    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bash binutils-unwrapped bison cmake coreutils cpio cyrus_sasl db ed
      expat flex gettext gmp gnugrep groff libedit libtool m4 ninja openldap openssh
      patchutils pbzx perl pkg-config.pkg-config python3 scons serf sqlite subversion
      sysctl.provider unzip which xz
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      ncurses libffi libiconv libxml2 zlib
      brotli curl libidn2 libiconv libkrb5 libssh2 libunistring nghttp2 openssl zlib zstd
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools locale libtapi print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ CF Libsystem ICU ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd libclosure libdispatch xnu ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.llvmPackages; [ compiler-rt libcxx libcxxabi ]);

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == lib.getVersion prevStage.darwin.cctools-port;

    stageFun prevStage {

    name = "bootstrap-stage2";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        autoconf automake bash bison cmake coreutils cpio cyrus_sasl db ed expat flex
        gettext gnugrep gmp groff libedit libtool m4 ninja openldap openssh patchutils pbzx
        perl pkg-config python3 scons serf sqlite subversion sysctl unzip which xz
        ncurses libffi libiconv libxml2 zlib
        brotli curl libidn2 libkrb5 libssh2 libunistring nghttp2 openssl zstd;

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        inherit (prevStage.darwin) CF ICU darwin-stubs launchd libiconv libobjc objc4 locale
        print-reexports rewrite-tbd sigtool signingUtils;

        # Rewrap binutils so it uses the rebuilt Libsystem.
        binutils = superDarwin.binutils.override {
          buildPackages = {
            inherit (prevStage) stdenv;
          };
          libc = selfDarwin.Libsystem;
        } // {
          passthru = { inherit (prevStage.bintools.passthru) isFromBootstrapFiles; };
        };
      });

      llvmPackages = super.llvmPackages // (
        let
          tools = super.llvmPackages.tools.extend (_: _: {
            inherit (prevStage.llvmPackages) clang-unwrapped libclang libllvm llvm;
            clang = prevStage.stdenv.cc;
          });
          libraries = super.llvmPackages.libraries.extend (_: _: {
            inherit (prevStage.llvmPackages) compiler-rt libcxx libcxxabi;
          });
        in
        { inherit tools libraries; inherit (prevStage.llvmPackages) release_version; } // tools // libraries
      );
    };

    extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
      prevStage.updateAutotoolsGnuConfigScriptsHook
      prevStage.gnu-config
    ];

    extraPreHook = ''
      stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
    '';
  })

  # Rebuild LLVM with LLVM.
  (prevStage:
    # previous stage2 stdenv:
    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bash bison cmake coreutils cpio cyrus_sasl db ed expat flex gettext
      gmp gnugrep groff libedit libtool m4 ninja openldap openssh patchutils pbzx perl
      pkg-config.pkg-config python3 scons serf sqlite subversion sysctl.provider unzip which xz
      ncurses libffi libiconv libxml2 zlib
      brotli curl libidn2 libiconv libkrb5 libssh2 libunistring nghttp2 openssl zlib zstd
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage; [
      binutils-unwrapped
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      locale print-reexports rewrite-tbd sigtool libiconv
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools libtapi
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ CF ICU ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF libobjc ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [ Libsystem ]);
    assert    useAppleSDKLibs  -> lib.all            isFromNixpkgs (with prevStage.darwin; [ Libsystem ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd libclosure libdispatch xnu ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.llvmPackages; [ libcxx libcxxabi ]);

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == lib.getVersion prevStage.darwin.cctools-llvm;

    stageFun prevStage {

    name = "bootstrap-stage3";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        autoconf automake bash binutils binutils-unwrapped bison cmake coreutils cpio
        cyrus_sasl db ed expat flex gettext gmp gnugrep groff libedit libtool m4 ninja
        openldap openssh patchutils pbzx perl pkg-config python3 scons sed serf sharutils
        sqlite subversion sysctl unzip which xz;

        # Rebuild the following dependencies along with LLVM, so it can link against them.
        # ncurses libffi libiconv libxml2 zlib

        # CF requires the following dependencies, which should be rebuilt along with it. CF is built
        # in this stage instead of along with libSystem because curl depends on libSystem.
        # brotli curl libidn2 libkrb5 libssh2 libunistring nghttp2 openssl zstd ICU

      libffi = super.libffi.override { doCheck = false; };

      # Avoid pulling in a full python and its extra dependencies for the llvm/clang builds.
      libxml2 = super.libxml2.override { pythonSupport = false; };

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        inherit (prevStage.darwin)
          Libsystem binutils binutils-unwrapped cctools cctools-llvm cctools-port
          configd darwin-stubs dyld launchd libclosure libdispatch libtapi locale
          postLinkSignHook print-reexports rewrite-tbd signingUtils sigtool;

          # CF on noon-source SDKs is CoreFoundation from `apple_sdk.frameworks`. It requires
          # libobjc. Rebuild them both together.
          # libobjc
      });

      llvmPackages = super.llvmPackages // (
        let
          libraries = super.llvmPackages.libraries.extend (_: _: {
           inherit (prevStage.llvmPackages) compiler-rt libcxx libcxxabi;
          });
        in
        { inherit libraries; } // libraries
      );
    };

    extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
      prevStage.updateAutotoolsGnuConfigScriptsHook
      prevStage.gnu-config
    ];

    extraPreHook = ''
      stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
    '';
  })

  # Construct a standard environment with the new clang. Also use the new compiler to rebuild
  # everything that will be part of the final stdenv.
  (prevStage:
    # previous stage3 stdenv:
    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bash bison cmake cpio coreutils cyrus_sasl db ed expat flex gettext
      gmp gnugrep groff libedit libtool m4 ninja openldap openssh patchutils pbzx perl
      pkg-config.pkg-config python3 scons serf sqlite subversion sysctl.provider unzip which xz
    ]);

    assert lib.all isBuiltByNixpkgsCompiler (with prevStage; [
      binutils-unwrapped curl ncurses libffi libiconv libxml2 zlib
      brotli curl libidn2 libiconv libkrb5 libssh2 libunistring nghttp2 openssl zlib zstd
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      locale print-reexports rewrite-tbd sigtool
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools libiconv libtapi
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [ CF Libsystem ICU ]);
    assert    useAppleSDKLibs  -> lib.all            isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd libclosure libdispatch xnu ]);

    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx libcxxabi
    ]);

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == lib.getVersion prevStage.darwin.cctools-llvm;

    stageFun prevStage {

    name = "bootstrap-stage4";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        autoconf automake bison cmake cpio cyrus_sasl db expat flex groff libedit libtool m4
        ninja openldap openssh patchutils pbzx perl pkg-config python3 scons serf sqlite
        subversion sysctl unzip which

        # These were built in an earlier stage to build LLVM and CF. Don’t rebuild them.
        ncurses libffi libiconv libxml2 zlib
        brotli curl libidn2 libkrb5 libssh2 libunistring nghttp2 openssl zstd;

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        inherit (prevStage.darwin) dyld CF ICU Libsystem darwin-stubs libiconv
          # libobjc is required by CoreFoundation on aarch64-darwin. Don’t rebuild it.
          libobjc objc4;

        signingUtils = superDarwin.signingUtils.override {
          inherit (selfDarwin) sigtool;
        };

        binutils = superDarwin.binutils.override {
          shell = self.bash + "/bin/bash";

          buildPackages = {
            inherit (prevStage) stdenv;
          };

          bintools = selfDarwin.binutils-unwrapped;
          libc = selfDarwin.Libsystem;
        };
      });

      llvmPackages = super.llvmPackages // (
        let
          tools = super.llvmPackages.tools.extend (_: _: {
            inherit (prevStage.llvmPackages) clang-unwrapped libclang libllvm llvm;
            libcxxClang = lib.makeOverridable (import ../../build-support/cc-wrapper) {
              nativeTools = false;
              nativeLibc = false;

              buildPackages = {
                inherit (prevStage) stdenv;
              };

              extraPackages = [
                self.llvmPackages.libcxxabi
                self.llvmPackages.compiler-rt
              ];

              extraBuildCommands =
                let
                  inherit (self.llvmPackages) clang-unwrapped compiler-rt release_version;
                in
                ''
                  rsrc="$out/resource-root"
                  mkdir "$rsrc"
                  ln -s "${clang-unwrapped.lib}/lib/clang/${release_version}/include" "$rsrc"
                  ln -s "${compiler-rt.out}/lib"   "$rsrc/lib"
                  ln -s "${compiler-rt.out}/share" "$rsrc/share"
                  echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
                '';

              cc = self.llvmPackages.clang-unwrapped;
              bintools = self.darwin.binutils;

              isClang = true;
              libc = self.darwin.Libsystem;
              inherit (self.llvmPackages) libcxx;

              inherit lib;
              inherit (self) stdenvNoCC coreutils gnugrep;

              shell = self.bash + "/bin/bash";
            };
          });
          libraries = super.llvmPackages.libraries.extend (_: _:{
            inherit (prevStage.llvmPackages) compiler-rt libcxx libcxxabi;
          });
        in
        { inherit tools libraries; } // tools // libraries
      );
    };

    extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
      prevStage.updateAutotoolsGnuConfigScriptsHook
      prevStage.gnu-config
    ];

    extraPreHook = ''
      stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
    '';
  })

  # Construct the final stdenv. The version of LLVM provided should match the one defined in
  # `all-packages.nix` for Darwin. Nothing should depend on the bootstrap tools or originate from
  # the bootstrap tools.
  #
  # When updating the Darwin stdenv, make sure that the result has no dependency (`nix-store -qR`)
  # on `bootstrapTools` or the binutils built in stage 1.
  (prevStage:
    # previous stage4 stdenv:
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage; [
      bash binutils-unwrapped brotli bzip2 curl diffutils ed file findutils gawk gettext gmp
      gnugrep gnumake gnused gnutar gzip libffi libiconv libidn2 libkrb5 libssh2 libunistring libxml2
      ncurses nghttp2 openssl patch pcre xz zlib zstd
    ]);

    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools libiconv locale
       libtapi print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [ CF Libsystem ICU libobjc ]);
    assert    useAppleSDKLibs  -> lib.all            isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd libclosure libdispatch xnu ]);

    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx libcxxabi
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bison cmake cpio cyrus_sasl db expat flex groff libedit libtool m4 ninja
      openldap openssh patchutils pbzx perl pkg-config.pkg-config python3 scons serf sqlite
      subversion sysctl.provider unzip which
    ]);

    assert prevStage.darwin.cctools == prevStage.darwin.cctools-llvm;

    let
      doSign = localSystem.isAarch64;

      persistent = self: super: {
        inherit (prevStage)
          bash binutils brotli bzip2 coreutils curl diffutils ed file findutils gawk gettext
          gmp gnugrep gnumake gnused gnutar gzip libffi libidn2 libiconv libssh2
          libunistring libxml2 ncurses nghttp2 openssl patch pre xz zlib zstd;

        darwin = super.darwin.overrideScope (_: _: {
          inherit (prevStage.darwin) dyld Libsystem CF ICU locale libobjc libtapi;
        } // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
          inherit (prevStage.darwin) binutils binutils-unwrapped cctools cctools-llvm cctools-port;
        });
      } // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
        inherit (prevStage) llvm;

        # Need to get rid of these when cross-compiling.
        llvmPackages = super.llvmPackages // (
          let
            tools = super.llvmPackages.tools.extend (_: _: {
              inherit (prevStage.llvmPackages) clang clang-unwrapped libclang libllvm llvm;
            });
            libraries = super.llvmPackages.libraries.extend (_: _: {
              inherit (prevStage.llvmPackages) compiler-rt libcxx libcxxabi;
            });
          in
          { inherit tools libraries; } // tools // libraries
        );

        inherit (prevStage) binutils binutils-unwrapped;
      };

      cc = prevStage.llvmPackages.clang;
    in
    {
    inherit config overlays;
    stdenv = import ../generic {
      name = "stdenv-darwin";

      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;

      inherit config;

      preHook = commonPreHook + ''
        stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
        export PATH_LOCALE=${prevStage.darwin.locale}/share/locale
      '';

      initialPath = ((import ../generic/common-path.nix) { pkgs = prevStage; });

      extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
        prevStage.updateAutotoolsGnuConfigScriptsHook
      ];

      extraBuildInputs = [ prevStage.darwin.CF ];

      inherit cc;

      shell = cc.shell;

      inherit (prevStage.stdenv) fetchurlBoot;

      extraAttrs = {
        inherit bootstrapTools;
        libc = prevStage.darwin.Libsystem;
        shellPackage = prevStage.bash;
      } // lib.optionalAttrs useAppleSDKLibs {
        # This objc4 will be propagated to all builds using the final stdenv,
        # and we shouldn't mix different builds, because they would be
        # conflicting LLVM modules. Export it here so we can grab it later.
        inherit (prevStage.darwin) objc4;
      };

      disallowedRequisites = [ bootstrapTools.out ];

      allowedRequisites = (with prevStage; [
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
        libiconv
        gnutar
        gzip
        ncurses.out
        ncurses.dev
        ncurses.man
        gnused
        bash
        gawk
        gnugrep
        gnugrep.pcre2.out
        patch
        gettext
        binutils.bintools
        binutils.bintools.lib
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
      ])
      ++ lib.optional haveKRB5 prevStage.libkrb5
      ++ lib.optionals localSystem.isAarch64 [
        prevStage.updateAutotoolsGnuConfigScriptsHook
        prevStage.gnu-config
      ]
      ++ (with prevStage.llvmPackages; [
        bintools-unwrapped
        libcxx
        libcxx.dev
        libcxxabi
        libcxxabi.dev
        lld
        llvm
        llvm.lib
        compiler-rt
        compiler-rt.dev
        clang-unwrapped
        clang-unwrapped.lib
      ])
      ++ (with prevStage.darwin; [
        dyld
        Libsystem
        CF
        cctools-llvm
        cctools-port
        ICU
        locale
        libtapi
      ]
      ++ lib.optional useAppleSDKLibs objc4
      ++ lib.optionals doSign [ postLinkSignHook sigtool signingUtils ]);

      __stdenvImpureHostDeps = commonImpureHostDeps;
      __extraImpureHostDeps = commonImpureHostDeps;

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
  })

  # This "no-op" stage is just a place to put the assertions about stage6.
  (prevStage:
    # previous final stage stdenv:
    assert isBuiltByNixpkgsCompiler prevStage.darwin.sigtool;
    assert isBuiltByNixpkgsCompiler prevStage.darwin.binutils-unwrapped;
    assert isBuiltByNixpkgsCompiler prevStage.darwin.print-reexports;
    assert isBuiltByNixpkgsCompiler prevStage.darwin.rewrite-tbd;
    assert isBuiltByNixpkgsCompiler prevStage.darwin.cctools;

    assert            isFromNixpkgs prevStage.darwin.CF;
    assert            isFromNixpkgs prevStage.darwin.Libsystem;

    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.clang-unwrapped;
    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.libllvm;
    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.libcxx;
    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.libcxxabi;
    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.compiler-rt;
    { inherit (prevStage) config overlays stdenv; })
]
