# This file contains the standard build environment for Darwin. It is based on LLVM and is patterned
# after the Linux stdenv. It shares similar goals to the Linux standard environment in that the
# resulting environment should be built purely and not contain any references to it.
#
# For more on the design of the stdenv and updating it, see `README.md`.
#
# See also the top comments of the Linux stdenv `../linux/default.nix` for a good overview of
# the bootstrap process and working with it.

{ lib
, localSystem
, crossSystem
, config
, overlays
, crossOverlays ? [ ]
  # Allow passing in bootstrap files directly so we can test the stdenv bootstrap process when changing the bootstrap tools
, bootstrapFiles ? if localSystem.isAarch64 then
    import ./bootstrap-files/aarch64-apple-darwin.nix
  else
    import ./bootstrap-files/x86_64-apple-darwin.nix
}:

assert crossSystem == localSystem;

let
  inherit (localSystem) system;

  useAppleSDKLibs = localSystem.isAarch64;

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
    builder = "${bootstrapFiles.unpack}/bin/bash";

    args = [
      "${bootstrapFiles.unpack}/bootstrap-tools-unpack.sh"
        bootstrapFiles.bootstrapTools
    ];

    PATH = lib.makeBinPath [
      (placeholder "out")
      bootstrapFiles.unpack
    ];

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

        expand-response-params = lib.optionalString
          (prevStage.stdenv.hasCC or false && prevStage.stdenv.cc != "/dev/null")
          prevStage.expand-response-params;

        extraPackages = [
          prevStage.llvmPackages.compiler-rt
        ];

        extraBuildCommands =
          let
            inherit (prevStage.llvmPackages) clang-unwrapped compiler-rt release_version;
          in
          ''
            function clangResourceRootIncludePath() {
              clangLib="$1/lib/clang"
              if (( $(ls "$clangLib" | wc -l) > 1 )); then
                echo "Multiple LLVM versions were found at "$clangLib", but there must only be one used when building the stdenv." >&2
                exit 1
              fi
              echo "$clangLib/$(ls -1 "$clangLib")/include"
            }

            rsrc="$out/resource-root"
            mkdir "$rsrc"
            ln -s "$(clangResourceRootIncludePath "${clang-unwrapped.lib}")" "$rsrc"
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
        runtimeShell = prevStage.ccWrapperStdenv.shell;
      };

      bash = prevStage.bash or bootstrapTools;

      thisStdenv = import ../generic {
        name = "${name}-stdenv-darwin";

        buildPlatform = localSystem;
        hostPlatform = localSystem;
        targetPlatform = localSystem;

        inherit config;

        extraBuildInputs = [ prevStage.darwin.CF ];
        extraNativeBuildInputs = extraNativeBuildInputs
          ++ [ prevStage.darwin.apple_sdk.sdkRoot ];

        preHook = lib.optionalString (!isBuiltByNixpkgsCompiler bash) ''
          # Don't patch #!/interpreter because it leads to retained
          # dependencies on the bootstrapTools in the final stdenv.
          dontPatchShebangs=1
        '' + ''
          ${commonPreHook}
          ${extraPreHook}
        '' + lib.optionalString (prevStage.darwin ? locale) ''
          export PATH_LOCALE=${prevStage.darwin.locale}/share/locale
        '';

        shell = bash + "/bin/bash";
        initialPath = [ bash bootstrapTools ];

        fetchurlBoot = import ../../build-support/fetchurl {
          inherit lib;
          stdenvNoCC = prevStage.ccWrapperStdenv or thisStdenv;
          curl = bootstrapTools;
        };

        inherit cc;

        # The stdenvs themselves don't use mkDerivation, so I need to specify this here
        __stdenvImpureHostDeps = commonImpureHostDeps;
        __extraImpureHostDeps = commonImpureHostDeps;

        # Using the bootstrap tools curl for fetchers allows the stdenv bootstrap to avoid
        # having a dependency on curl, allowing curl to be updated without triggering a
        # new stdenv bootstrap on Darwin.
        overrides = self: super: (overrides self super) // {
          fetchurl = thisStdenv.fetchurlBoot;
          fetchpatch = super.fetchpatch.override { inherit (self) fetchurl; };
          fetchgit = super.fetchgit.override {
            git = super.git.override { curl = bootstrapTools; };
          };
          fetchzip = super.fetchzip.override { inherit (self) fetchurl; };
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
      apple_sdk.sdkRoot = null;
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

      bash = bootstrapTools;
      coreutils = bootstrapTools;
      cpio = bootstrapTools;
      gnugrep = bootstrapTools;
      pbzx = bootstrapTools;

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        # Prevent CF from being propagated to the initial stdenv. Packages that require it
        # will have to manually add it to their build inputs.
        CF = null;

        binutils-unwrapped = bootstrapTools // {
          version = "boot";
        };

        binutils = super.wrapBintoolsWith {
          name = "bootstrap-stage0-binutils-wrapper";

          nativeTools = false;
          nativeLibc = false;

          expand-response-params = "";
          libc = selfDarwin.Libsystem;

          inherit lib;
          inherit (self) stdenvNoCC coreutils gnugrep;
          runtimeShell = self.stdenvNoCC.shell;

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
              passthru = {
                isFromBootstrapFiles = true;
                hardeningUnsupportedFlags = [ "fortify3" "zerocallusedregs" ];
              };
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
        { inherit tools libraries; } // tools // libraries
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
    assert lib.all isFromBootstrapFiles (
      with prevStage; [ bash coreutils cpio gnugrep ] ++ lib.optionals useAppleSDKLibs [ pbzx ]
    );

    assert lib.all isFromBootstrapFiles (with prevStage.darwin; [
      binutils-unwrapped cctools print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isFromBootstrapFiles (with prevStage.darwin; [ Libsystem ]);
    assert    useAppleSDKLibs  -> lib.all        isFromNixpkgs (with prevStage.darwin; [ Libsystem ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd xnu ]);
    assert (with prevStage.darwin; (! useAppleSDKLibs) -> CF == null);

    assert lib.all isFromBootstrapFiles (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx
    ]);

    stageFun prevStage {
    name = "bootstrap-stage1";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        coreutils gnugrep;

      # Use this stage’s CF to build CMake. It’s required but can’t be included in the stdenv.
      cmake = self.cmakeMinimal;
      cmakeMinimal = super.cmakeMinimal.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ self.darwin.CF ];
      });

      # Disable tests because they use dejagnu, which fails to run.
      libffi = super.libffi.override { doCheck = false; };

      # Use libconvReal to break an infinite recursion. It will be dropped in the next stage.
      libiconv = super.libiconvReal;

      # Avoid pulling in a full python and its extra dependencies for the llvm/clang builds.
      libxml2 = super.libxml2.override { pythonSupport = false; };

      ninja = super.ninja.override { buildDocs = false; };

      # Use this stage’s CF to build Python. It’s required but can’t be included in the stdenv.
      python3 = self.python3Minimal;
      python3Minimal = super.python3Minimal.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ self.darwin.CF ];
      });

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        apple_sdk = superDarwin.apple_sdk // {
          inherit (prevStage.darwin.apple_sdk) sdkRoot;
        };

        # Use this stage’s CF to build configd. It’s required but can’t be included in the stdenv.
        configd = superDarwin.configd.overrideAttrs (old: {
          buildInputs = old.buildInputs or [ ] ++ [ self.darwin.CF ];
        });

        signingUtils = prevStage.darwin.signingUtils.override {
          inherit (selfDarwin) sigtool;
        };

        postLinkSignHook = prevStage.darwin.postLinkSignHook.override {
          inherit (selfDarwin) sigtool;
        };

        binutils = superDarwin.binutils.override {
          inherit (self) coreutils;
          inherit (selfDarwin) postLinkSignHook signingUtils;

          bintools = selfDarwin.binutils-unwrapped;
          libc = selfDarwin.Libsystem;
          # TODO(@sternenseemann): can this be removed?
          runtimeShell = "${bootstrapTools}/bin/bash";
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
            inherit (prevStage.llvmPackages) compiler-rt libcxx;
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

      # Don’t assume the ld64 in bootstrap tools supports response files. Only recent versions do.
      export NIX_LD_USE_RESPONSE_FILE=0
    '';
  })

  # Build cctools, Python, and sysctl for use by LLVM’s check phase. They must be built in
  # their stage to prevent infinite recursions and to make sure the stdenv used to build
  # LLVM has the newly built cctools instead of the one from the bootstrap tools.
  (prevStage:
    # previous stage1 stdenv:
    assert lib.all isFromBootstrapFiles (with prevStage; [ coreutils gnugrep ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bash binutils-unwrapped bison brotli cmake cpio cyrus_sasl db
      ed expat flex gettext gmp groff icu libedit libffi libiconv libidn2 libkrb5 libssh2
      libtool libunistring libxml2 m4 ncurses nghttp2 ninja openldap openssh openssl
      patchutils pbzx perl pkg-config.pkg-config python3 python3Minimal scons serf sqlite
      subversion texinfo unzip which xz zlib zstd
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools locale libtapi print-reexports rewrite-tbd sigtool
    ]);
    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ Libsystem configd ]);
    assert (! useAppleSDKLibs) -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd xnu ]);

    assert lib.all isFromBootstrapFiles (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx
    ]);

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == "boot";

    stageFun prevStage {
    name = "bootstrap-stage1-sysctl";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        autoconf automake bash binutils binutils-unwrapped bison brotli cmake cmakeMinimal
        coreutils cpio cyrus_sasl db ed expat flex gettext gmp gnugrep groff icu
        libedit libffi libidn2 libkrb5 libssh2 libtool libunistring libxml2 m4
        ncurses nghttp2 ninja openldap openssh openssl patchutils pbzx perl pkg-config
        python3Minimal scons sed serf sharutils sqlite subversion texinfo unzip which xz
        zlib zstd;

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
          CF sdkRoot Libsystem binutils-unwrapped cctools cctools-port configd darwin-stubs dyld
          launchd libclosure libdispatch libobjc locale objc4 postLinkSignHook
          print-reexports rewrite-tbd signingUtils sigtool;

        apple_sdk = superDarwin.apple_sdk // {
          inherit (prevStage.darwin.apple_sdk) sdkRoot;
        };
      });

      llvmPackages = super.llvmPackages // (
        let
          tools = super.llvmPackages.tools.extend (_: _: {
            inherit (prevStage.llvmPackages) clang-unwrapped libclang libllvm llvm;
            clang = prevStage.stdenv.cc;
          });
          libraries = super.llvmPackages.libraries.extend (_: _: {
            inherit (prevStage.llvmPackages) compiler-rt libcxx;
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
      atf autoconf automake bash binutils-unwrapped bison brotli cmake cpio cyrus_sasl db
      ed expat flex gettext gmp groff icu kyua libedit libffi libiconv libidn2 libkrb5 libssh2
      libtool libunistring libxml2 m4 ncurses nghttp2 ninja openldap openssh openssl
      patchutils pbzx perl pkg-config.pkg-config python3 python3Minimal scons serf sqlite
      subversion sysctl.provider texinfo unzip which xz zlib zstd
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools locale libtapi print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ Libsystem configd ]);
    assert (! useAppleSDKLibs) -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd xnu ]);

    assert lib.all isFromBootstrapFiles (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx
    ]);

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == lib.getVersion prevStage.darwin.cctools-port;

    stageFun prevStage {
    name = "bootstrap-stage-xclang";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        atf autoconf automake bash binutils binutils-unwrapped bison brotli cmake cmakeMinimal
        cpio cyrus_sasl db ed expat flex gettext gmp groff icu kyua libedit libffi libiconv
        libidn2 libkrb5 libssh2 libtool libunistring libxml2 m4 ncurses nghttp2 ninja
        openldap openssh openssl patchutils pbzx perl pkg-config python3 python3Minimal
        scons sed serf sharutils sqlite subversion sysctl texinfo unzip which xz zlib zstd;

      # Switch from cctools-port to cctools-llvm now that LLVM has been built.
      darwin = super.darwin.overrideScope (_: superDarwin: {
        inherit (prevStage.darwin)
          CF Libsystem configd darwin-stubs dyld launchd libclosure libdispatch libobjc
          locale objc4 postLinkSignHook print-reexports rewrite-tbd signingUtils sigtool;

        apple_sdk = superDarwin.apple_sdk // {
          inherit (prevStage.darwin.apple_sdk) sdkRoot;
        };

        # Avoid building unnecessary Python dependencies due to building LLVM manpages.
        cctools-llvm = superDarwin.cctools-llvm.override { enableManpages = false; };
      });

      llvmPackages = super.llvmPackages // (
        let
          llvmMajor = lib.versions.major super.llvmPackages.release_version;

          # libc++, and libc++abi do not need CoreFoundation. Avoid propagating the CF from prior
          # stages to the final stdenv via rpath by dropping it from `extraBuildInputs`.
          stdenvNoCF = self.stdenv.override {
            extraBuildInputs = [ ];
          };

          libcxxBootstrapStdenv = self.overrideCC stdenvNoCF (self.llvmPackages.clangNoCompilerRtWithLibc.override {
            nixSupport.cc-cflags = [ "-nostdlib" ];
            nixSupport.cc-ldflags = [ "-lSystem" ];
          });

          libraries = super.llvmPackages.libraries.extend (selfLib: superLib: {
            compiler-rt = null;
            libcxx = superLib.libcxx.override ({
              stdenv = libcxxBootstrapStdenv;
            });
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
      stripAllFlags=" "    # the cctools "strip" command doesn't know "-s"
      stripDebugFlags="-S" # the cctools "strip" command does something odd with "-p"
    '';
  })

  # This stage rebuilds Libsystem. It also rebuilds bash, which will be needed in later stages
  # to use in patched shebangs (e.g., to make sure `icu-config` uses bash from nixpkgs).
  (prevStage:
    # previous stage-xclang stdenv:
    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      atf autoconf automake bash binutils-unwrapped bison cmake cmakeMinimal coreutils cpio
      cyrus_sasl db ed expat flex gettext gmp gnugrep groff icu kyua libedit libtool m4 ninja
      openbsm openldap openpam openssh patchutils pbzx perl pkg-config.pkg-config python3
      python3Minimal scons serf sqlite subversion sysctl.provider texinfo unzip which xz
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      brotli libffi libiconv libidn2 libkrb5 libssh2 libunistring libxml2 ncurses
      nghttp2 openssl zlib zstd
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools locale libtapi print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ Libsystem configd ]);
    assert (! useAppleSDKLibs) -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd libclosure libdispatch xnu ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.llvmPackages; [ libcxx ]);
    assert prevStage.llvmPackages.compiler-rt == null;

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == lib.getVersion prevStage.darwin.cctools-port;

    stageFun prevStage {

    name = "bootstrap-stage2-Libsystem";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        atf autoconf automake binutils-unwrapped bison brotli cmake cmakeMinimal coreutils
        cpio cyrus_sasl db ed expat flex gettext gmp gnugrep groff icu kyua libedit libffi
        libiconv libidn2 libkrb5 libssh2 libtool libunistring libxml2 m4 ncurses nghttp2
        ninja openbsm openldap openpam openssh openssl patchutils pbzx perl pkg-config
        python3 python3Minimal scons serf sqlite subversion sysctl texinfo unzip which xz
        zlib zstd;

      # Bash must be linked against the system CoreFoundation instead of the open-source one.
      # Otherwise, there will be a dependency cycle: bash -> CF -> icu -> bash (for icu^dev).
      bash = super.bash.overrideAttrs (super: {
        buildInputs = super.buildInputs ++ [ self.darwin.apple_sdk.frameworks.CoreFoundation ];
      });

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        inherit (prevStage.darwin)
          CF binutils-unwrapped cctools configd darwin-stubs launchd libobjc libtapi locale
          objc4 print-reexports rewrite-tbd signingUtils sigtool;

        apple_sdk = superDarwin.apple_sdk // {
          inherit (prevStage.darwin.apple_sdk) sdkRoot;
        };
      });

      llvmPackages = super.llvmPackages // (
        let
          tools = super.llvmPackages.tools.extend (_: _: {
            inherit (prevStage.llvmPackages) clang-unwrapped clangNoCompilerRtWithLibc libclang libllvm llvm;
          });

          libraries = super.llvmPackages.libraries.extend (selfLib: superLib: {
            inherit (prevStage.llvmPackages) compiler-rt libcxx;
          });
        in
        { inherit tools libraries; inherit (prevStage.llvmPackages) release_version; } // tools // libraries
      );

      # Don’t link anything in this stage against CF to prevent propagating CF from prior stages to
      # the final stdenv, which happens because of the rpath hook.
      stdenv =
        let
          stdenvNoCF = super.stdenv.override {
            extraBuildInputs = [ ];
          };
        in
        self.overrideCC stdenvNoCF (self.llvmPackages.clangNoCompilerRtWithLibc.override {
          inherit (self.llvmPackages) libcxx;
        });
    };

    extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
      prevStage.updateAutotoolsGnuConfigScriptsHook
      prevStage.gnu-config
    ];

    extraPreHook = ''
      stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
    '';
  })

  # This stage rebuilds CF, compiler-rt, and the sdkRoot derivation.
  #
  # CF requires:
  # - aarch64-darwin: libobjc (due to being apple_sdk.frameworks.CoreFoundation instead of swift-corefoundation)
  # - x86_64-darwin: libiconv libxml2 icu zlib
  (prevStage:
    # previous stage2-Libsystem stdenv:
    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      atf autoconf automake binutils-unwrapped bison brotli cmake cmakeMinimal coreutils
      cpio cyrus_sasl db ed expat flex gettext gmp gnugrep groff icu kyua libedit libidn2
      libkrb5 libssh2 libtool libunistring m4 nghttp2 ninja openbsm openldap openpam openssh
      openssl patchutils pbzx perl pkg-config.pkg-config python3 python3Minimal scons serf
      sqlite subversion sysctl.provider texinfo unzip which xz zstd
    ]);

    assert lib.all isBuiltByNixpkgsCompiler (with prevStage; [ bash ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      libffi libiconv libxml2 ncurses zlib zstd
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools locale libtapi print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ configd ]);
    assert (! useAppleSDKLibs) -> lib.all        isBuiltByNixpkgsCompiler (with prevStage.darwin; [ Libsystem ]);
    assert (! useAppleSDKLibs) -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd libclosure libdispatch xnu ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.llvmPackages; [ libcxx ]);
    assert prevStage.llvmPackages.compiler-rt == null;

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == lib.getVersion prevStage.darwin.cctools-llvm;

    stageFun prevStage {

    name = "bootstrap-stage2-CF";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        atf autoconf automake bash bison brotli cmake cmakeMinimal coreutils cpio
        cyrus_sasl db ed expat flex gettext gmp gnugrep groff kyua libedit libidn2 libkrb5
        libssh2 libtool libunistring m4 ncurses nghttp2 ninja openbsm openldap openpam
        openssh openssl patchutils pbzx perl pkg-config python3 python3Minimal scons serf
        sqlite subversion sysctl texinfo unzip which xz zstd;

      # Avoid pulling in a full python and its extra dependencies for the llvm/clang builds.
      libxml2 = super.libxml2.override { pythonSupport = false; };

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        inherit (prevStage.darwin)
          Libsystem configd darwin-stubs launchd locale print-reexports rewrite-tbd
          signingUtils sigtool;

        # Rewrap binutils so it uses the rebuilt Libsystem.
        binutils = superDarwin.binutils.override {
          inherit (prevStage) expand-response-params;
          libc = selfDarwin.Libsystem;
        } // {
          passthru = { inherit (prevStage.bintools.passthru) isFromBootstrapFiles; };
        };

        # Avoid building unnecessary Python dependencies due to building LLVM manpages.
        cctools-llvm = superDarwin.cctools-llvm.override { enableManpages = false; };
      });

      llvmPackages = super.llvmPackages // (
        let
          tools = super.llvmPackages.tools.extend (_: _: {
            inherit (prevStage.llvmPackages) clang-unwrapped clangNoCompilerRtWithLibc libclang lld libllvm llvm;
            clang = prevStage.stdenv.cc;
          });

          libraries = super.llvmPackages.libraries.extend (selfLib: superLib: {
            inherit (prevStage.llvmPackages) libcxx;

            # Make sure compiler-rt is linked against the CF from this stage, which can be
            # propagated to the final stdenv. CF is required by ASAN.
            compiler-rt = superLib.compiler-rt.override ({
              inherit (self.llvmPackages) libllvm;
              stdenv = self.stdenv.override {
                extraBuildInputs = [ self.darwin.CF ];
              };
            });
          });
        in
        { inherit tools libraries; inherit (prevStage.llvmPackages) release_version; } // tools // libraries
      );

      # Don’t link anything in this stage against CF to prevent propagating CF from prior stages to
      # the final stdenv, which happens because of the rpath hook. Also don’t use a stdenv with
      # compiler-rt because it needs to be built in this stage.
      stdenv =
        let
          stdenvNoCF = super.stdenv.override {
            extraBuildInputs = [ ];
          };
        in
        self.overrideCC stdenvNoCF (self.llvmPackages.clangNoCompilerRtWithLibc.override {
          inherit (self.llvmPackages) libcxx;

          # Make sure the stdenv is using the Libsystem that will be propagated to the final stdenv.
          libc = self.darwin.Libsystem;
          bintools = self.llvmPackages.clangNoCompilerRtWithLibc.bintools.override {
            libc = self.darwin.Libsystem;
          };
        });
    };

    extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
      prevStage.updateAutotoolsGnuConfigScriptsHook
      prevStage.gnu-config
    ];

    extraPreHook = ''
      stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
    '';
  })

  # Rebuild LLVM with LLVM. This stage also rebuilds certain dependencies needed by LLVM.
  #
  # LLVM requires: libcxx libffi libiconv libxml2 ncurses zlib
  (prevStage:
    # previous stage2-CF stdenv:
    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bison brotli cmake cmakeMinimal coreutils cpio cyrus_sasl
      db ed expat flex gettext gmp gnugrep groff libedit libidn2 libkrb5 libssh2 libtool
      libunistring m4 ncurses nghttp2 ninja openbsm openldap openpam openssh openssl
      patchutils pbzx perl pkg-config.pkg-config python3 python3Minimal scons serf sqlite
      subversion sysctl.provider texinfo unzip which xz zstd
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage; [
      bash binutils-unwrapped icu libffi libiconv libxml2 zlib
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      locale print-reexports rewrite-tbd sigtool
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools libtapi
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ configd ]);
    assert (! useAppleSDKLibs) -> lib.all        isBuiltByNixpkgsCompiler (with prevStage.darwin; [ Libsystem ]);
    assert (! useAppleSDKLibs) -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd libclosure libdispatch xnu ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.llvmPackages; [ libcxx ]);

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == lib.getVersion prevStage.darwin.cctools-llvm;

    stageFun prevStage {

    name = "bootstrap-stage3";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        autoconf automake bash binutils binutils-unwrapped bison brotli cmake cmakeMinimal
        coreutils cpio cyrus_sasl db ed expat flex gettext gmp gnugrep groff libedit
        libidn2 libkrb5 libssh2 libtool libunistring m4 nghttp2 ninja openbsm openldap
        openpam openssh openssl patchutils pbzx perl pkg-config python3 python3Minimal scons
        sed serf sharutils sqlite subversion sysctl texinfo unzip which xz zstd

        # CF dependencies - don’t rebuild them.
        icu libiconv libiconv-darwin libxml2 zlib;

      # Disable tests because they use dejagnu, which fails to run.
      libffi = super.libffi.override { doCheck = false; };

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        inherit (prevStage.darwin)
          CF Libsystem binutils binutils-unwrapped cctools cctools-llvm cctools-port configd
          darwin-stubs dyld launchd libclosure libdispatch libobjc libtapi locale objc4
          postLinkSignHook print-reexports rewrite-tbd signingUtils sigtool;

        apple_sdk = superDarwin.apple_sdk // {
          inherit (prevStage.darwin.apple_sdk) sdkRoot;
        };
      });

      llvmPackages = super.llvmPackages // (
        let
          libraries = super.llvmPackages.libraries.extend (_: _: {
           inherit (prevStage.llvmPackages) compiler-rt libcxx;
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
  # everything that will be part of the final stdenv and isn’t required by it, CF, or Libsystem.
  (prevStage:
    # previous stage3 stdenv:
    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bison brotli cmake cmakeMinimal coreutils cpio cyrus_sasl
      db ed expat flex gettext gmp gnugrep groff libedit libidn2 libkrb5 libssh2 libtool
      libunistring m4 nghttp2 ninja openbsm openldap openpam openssh openssl patchutils pbzx
      perl pkg-config.pkg-config python3 python3Minimal scons serf sqlite subversion
      sysctl.provider texinfo unzip which xz zstd
    ]);

    assert lib.all isBuiltByNixpkgsCompiler (with prevStage; [
      bash binutils-unwrapped icu libffi libiconv libxml2 zlib
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [
      locale print-reexports rewrite-tbd sigtool
    ]);
    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools libtapi
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByBootstrapFilesCompiler (with prevStage.darwin; [ configd ]);
    assert (! useAppleSDKLibs) -> lib.all        isBuiltByNixpkgsCompiler (with prevStage.darwin; [ Libsystem ]);
    assert (! useAppleSDKLibs) -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF ]);
    assert    useAppleSDKLibs  -> lib.all                   isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd libclosure libdispatch xnu ]);

    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx
    ]);

    assert lib.getVersion prevStage.stdenv.cc.bintools.bintools == lib.getVersion prevStage.darwin.cctools-llvm;

    stageFun prevStage {

    name = "bootstrap-stage4";

    overrides = self: super: {
      inherit (prevStage) ccWrapperStdenv
        autoconf automake bash bison cmake cmakeMinimal cyrus_sasl db expat flex groff
        libedit libtool m4 ninja openldap openssh patchutils perl pkg-config python3 scons
        serf sqlite subversion sysctl texinfo unzip which

        # CF dependencies - don’t rebuild them.
        icu

        # LLVM dependencies - don’t rebuild them.
        libffi libiconv libiconv-darwin libxml2 ncurses zlib;

      darwin = super.darwin.overrideScope (selfDarwin: superDarwin: {
        inherit (prevStage.darwin) dyld CF Libsystem darwin-stubs
          # CF dependencies - don’t rebuild them.
          libobjc objc4;

        apple_sdk = superDarwin.apple_sdk // {
          inherit (prevStage.darwin.apple_sdk) sdkRoot;
        };

        signingUtils = superDarwin.signingUtils.override {
          inherit (selfDarwin) sigtool;
        };

        binutils = superDarwin.binutils.override {
          inherit (prevStage) expand-response-params;

          bintools = selfDarwin.binutils-unwrapped;
          libc = selfDarwin.Libsystem;
        };

        # cctools needs to build the LLVM man pages, which requires sphinx. Sphinx
        # has hatch-vcs as a transitive dependency, which pulls in git (and curl).
        # Disabling the tests for hatch-vcs allows the stdenv bootstrap to avoid having
        # any dependency on curl other than the one provided in the bootstrap tools.
        cctools-llvm = superDarwin.cctools-llvm.override (old: {
          llvmPackages =
            let
              tools = old.llvmPackages.tools.extend (_: superTools: {
                llvm-manpages = superTools.llvm-manpages.override {
                  python3Packages = prevStage.python3Packages.overrideScope (_: superPython: {
                    hatch-vcs = (superPython.hatch-vcs.override {
                      git = null;
                      pytestCheckHook = null;
                    });
                  });
                };
              });
              inherit (old.llvmPackages) libraries release_version;
            in
            { inherit tools libraries release_version; } // tools // libraries;
        });
      });

      llvmPackages = super.llvmPackages // (
        let
          tools = super.llvmPackages.tools.extend (_: _: {
            inherit (prevStage.llvmPackages) clang-unwrapped libclang libllvm llvm;
            libcxxClang = lib.makeOverridable (import ../../build-support/cc-wrapper) {
              nativeTools = false;
              nativeLibc = false;

              inherit (prevStage) expand-response-params;

              extraPackages = [
                self.llvmPackages.compiler-rt
              ];

              extraBuildCommands =
                let
                  inherit (self.llvmPackages) clang-unwrapped compiler-rt release_version;

                  # Clang 16+ uses only the major version in resource-root, but older versions use the complete one.
                  clangResourceRootIncludePath = clangLib: clangRelease:
                    let
                      clangVersion =
                        if lib.versionAtLeast clangRelease "16"
                        then lib.versions.major clangRelease
                        else clangRelease;
                    in
                    "${clangLib}/lib/clang/${clangVersion}/include";
                in
                ''
                  rsrc="$out/resource-root"
                  mkdir "$rsrc"
                  ln -s "${clangResourceRootIncludePath clang-unwrapped.lib release_version}" "$rsrc"
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
              inherit (self) stdenvNoCC coreutils gnugrep runtimeShell;
            };
          });
          libraries = super.llvmPackages.libraries.extend (_: _:{
            inherit (prevStage.llvmPackages) compiler-rt libcxx;
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
      bash binutils-unwrapped brotli bzip2 cpio diffutils ed file findutils gawk
      gettext gmp gnugrep gnumake gnused gnutar gzip icu libffi libiconv libidn2 libkrb5
      libssh2 libunistring libxml2 libyaml ncurses nghttp2 openbsm openpam openssl patch
      pbzx pcre python3Minimal xar xz zlib zstd
    ]);

    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [
      binutils-unwrapped cctools libtapi locale print-reexports rewrite-tbd sigtool
    ]);

    assert (! useAppleSDKLibs) -> lib.all isBuiltByNixpkgsCompiler (with prevStage.darwin; [ Libsystem configd ]);
    assert (! useAppleSDKLibs) -> lib.all            isFromNixpkgs (with prevStage.darwin; [ CF ]);
    assert    useAppleSDKLibs  -> lib.all            isFromNixpkgs (with prevStage.darwin; [ CF Libsystem libobjc ]);
    assert lib.all isFromNixpkgs (with prevStage.darwin; [ dyld launchd libclosure libdispatch xnu ]);

    assert lib.all isBuiltByNixpkgsCompiler (with prevStage.llvmPackages; [
      clang-unwrapped libclang libllvm llvm compiler-rt libcxx
    ]);

    assert lib.all isBuiltByBootstrapFilesCompiler (with prevStage; [
      autoconf automake bison cmake cmakeMinimal cyrus_sasl db expat flex groff libedit
      libtool m4 ninja openldap openssh patchutils perl pkg-config.pkg-config python3 scons
      serf sqlite subversion sysctl.provider texinfo unzip which
    ]);

    assert prevStage.darwin.cctools == prevStage.darwin.cctools-llvm;

    let
      doSign = localSystem.isAarch64;

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

      preHook = ''
        ${commonPreHook}
        stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
        export PATH_LOCALE=${prevStage.darwin.locale}/share/locale
      '';

      initialPath = ((import ../generic/common-path.nix) { pkgs = prevStage; });

      extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
        prevStage.updateAutotoolsGnuConfigScriptsHook
      ] ++ [ prevStage.darwin.apple_sdk.sdkRoot ];

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
        bash
        binutils.bintools
        binutils.bintools.lib
        bzip2.bin
        bzip2.out
        cc.expand-response-params
        coreutils
        darwin.binutils
        darwin.binutils.bintools
        diffutils
        ed
        file
        findutils
        gawk
        gettext
        gmp.out
        gnugrep
        gnugrep.pcre2.out
        gnumake
        gnused
        gnutar
        gzip
        icu.out
        libffi.out
        libiconv
        libunistring.out
        libxml2.out
        ncurses.dev
        ncurses.man
        ncurses.out
        openbsm
        openpam
        patch
        xz.bin
        xz.out
        zlib.dev
        zlib.out
      ]
      ++ lib.optionals doSign [ openssl.out ])
      ++ lib.optionals localSystem.isAarch64 [
        prevStage.updateAutotoolsGnuConfigScriptsHook
        prevStage.gnu-config
      ]
      ++ (with prevStage.llvmPackages; [
        bintools-unwrapped
        clang-unwrapped
        clang-unwrapped.lib
        compiler-rt
        compiler-rt.dev
        libcxx
        libcxx.dev
        lld
        llvm
        llvm.lib
      ])
      ++ (with prevStage.darwin; [
        CF
        Libsystem
        cctools-llvm
        cctools-port
        dyld
        libtapi
        locale
        apple_sdk.sdkRoot
      ]
      ++ lib.optional useAppleSDKLibs [ objc4 ]
      ++ lib.optionals doSign [ postLinkSignHook sigtool signingUtils ]);

      __stdenvImpureHostDeps = commonImpureHostDeps;
      __extraImpureHostDeps = commonImpureHostDeps;

      overrides = self: super: {
        inherit (prevStage)
          bash binutils brotli bzip2 coreutils cpio diffutils ed file findutils gawk
          gettext gmp gnugrep gnumake gnused gnutar gzip icu libffi libiconv libiconv-darwin
          libidn2 libssh2 libunistring libxml2 libyaml ncurses nghttp2 openbsm openpam
          openssl patch pbzx pcre python3Minimal xar xz zlib zstd;

        darwin = super.darwin.overrideScope (_: superDarwin: {
          inherit (prevStage.darwin)
            CF ICU Libsystem darwin-stubs dyld locale libobjc libtapi rewrite-tbd xnu;

          apple_sdk = superDarwin.apple_sdk // {
            inherit (prevStage.darwin.apple_sdk) sdkRoot;
          };
        } // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
          inherit (prevStage.darwin) binutils binutils-unwrapped cctools-llvm cctools-port;
        });
      } // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
        inherit (prevStage.llvmPackages) clang llvm;

        # Need to get rid of these when cross-compiling.
        llvmPackages = super.llvmPackages // (
          let
            tools = super.llvmPackages.tools.extend (_: _: {
              inherit (prevStage.llvmPackages) clang clang-unwrapped libclang libllvm llvm;
            });
            libraries = super.llvmPackages.libraries.extend (_: _: {
              inherit (prevStage.llvmPackages) compiler-rt libcxx;
            });
          in
          { inherit tools libraries; } // tools // libraries
        );

        inherit (prevStage) binutils binutils-unwrapped;
      };
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
    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.compiler-rt;
    { inherit (prevStage) config overlays stdenv; })
]
