# This file contains the standard build environment for Darwin. It is based on LLVM and is patterned
# after the Linux stdenv. It shares similar goals to the Linux standard environment in that the
# resulting environment should be built purely and not contain any references to it.
#
# For more on the design of the stdenv and updating it, see `README.md`.
#
# See also the top comments of the Linux stdenv `../linux/default.nix` for a good overview of
# the bootstrap process and working with it.

{
  lib,
  localSystem,
  crossSystem,
  config,
  overlays,
  crossOverlays ? [ ],
  # Allow passing in bootstrap files directly so we can test the stdenv bootstrap process when changing the bootstrap tools
  bootstrapFiles ? (config.replaceBootstrapFiles or lib.id) (
    if localSystem.isAarch64 then
      import ./bootstrap-files/aarch64-apple-darwin.nix
    else
      import ./bootstrap-files/x86_64-apple-darwin.nix
  ),
}:

assert crossSystem == localSystem;

let
  inherit (localSystem) system;

  sdkMajorVersion =
    let
      inherit (localSystem) darwinSdkVersion;
    in
    if lib.versionOlder darwinSdkVersion "11" then
      lib.versions.majorMinor darwinSdkVersion
    else
      lib.versions.major darwinSdkVersion;

  commonImpureHostDeps = [
    "/bin/sh"
    "/usr/lib/libSystem.B.dylib"
    "/usr/lib/system/libunc.dylib" # This dependency is "hidden", so our scanning code doesn't pick it up
  ];

  isFromNixpkgs = pkg: !(isFromBootstrapFiles pkg);
  isFromBootstrapFiles = pkg: pkg.passthru.isFromBootstrapFiles or false;
  isBuiltByNixpkgsCompiler = pkg: isFromNixpkgs pkg && isFromNixpkgs pkg.stdenv.cc.cc;
  isBuiltByBootstrapFilesCompiler = pkg: isFromNixpkgs pkg && isFromBootstrapFiles pkg.stdenv.cc.cc;

  # Dependencies in dependency sets should be mutually exclusive.
  mergeDisjointAttrs = lib.foldl' lib.attrsets.unionOfDisjoint { };

  commonPreHook = ''
    export NIX_ENFORCE_NO_NATIVE=''${NIX_ENFORCE_NO_NATIVE-1}
    export NIX_ENFORCE_PURITY=''${NIX_ENFORCE_PURITY-1}
    export NIX_IGNORE_LD_THROUGH_GCC=1
  '';

  bootstrapTools =
    derivation (
      {
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
      }
      // lib.optionalAttrs config.contentAddressedByDefault {
        __contentAddressed = true;
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
      }
    )
    // {
      passthru.isFromBootstrapFiles = true;
    };

  stageFun =
    prevStage:
    {
      name,
      overrides ? (self: super: { }),
      extraNativeBuildInputs ? [ ],
      extraPreHook ? "",
    }:

    let
      cc =
        if prevStage.llvmPackages.clang-unwrapped == null then
          null
        else
          prevStage.wrapCCWith {
            name = "${name}-clang-wrapper";

            nativeTools = false;
            nativeLibc = false;

            expand-response-params = lib.optionalString (
              prevStage.stdenv.hasCC or false && prevStage.stdenv.cc != "/dev/null"
            ) prevStage.expand-response-params;

            extraPackages = [ prevStage.llvmPackages.compiler-rt ];

            extraBuildCommands =
              let
                inherit (prevStage.llvmPackages) clang-unwrapped compiler-rt;
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
                ln -s "$(clangResourceRootIncludePath "${lib.getLib clang-unwrapped}")" "$rsrc"
                ln -s "${compiler-rt.out}/lib"   "$rsrc/lib"
                ln -s "${compiler-rt.out}/share" "$rsrc/share"
                echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
              ''
              + lib.optionalString (isFromBootstrapFiles prevStage.llvmPackages.clang-unwrapped) ''
                # Work around the `-nostdlibinc` patch in the bootstrap tools.
                # TODO: Remove after the bootstrap tools have been updated.
                substituteAll ${builtins.toFile "add-flags-extra.sh" ''
                  if [ "@darwinMinVersion@" ]; then
                    NIX_CFLAGS_COMPILE_@suffixSalt@+=" -idirafter $SDKROOT/usr/include"
                    NIX_CFLAGS_COMPILE_@suffixSalt@+=" -iframework $SDKROOT/System/Library/Frameworks"
                  fi
                ''} add-flags-extra.sh
                cat add-flags-extra.sh >> $out/nix-support/add-flags.sh
              '';

            cc = prevStage.llvmPackages.clang-unwrapped;
            bintools = prevStage.darwin.binutils;

            isClang = true;
            libc = prevStage.darwin.libSystem;
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

        extraBuildInputs = [ prevStage.apple-sdk ];
        inherit extraNativeBuildInputs;

        preHook =
          lib.optionalString (!isBuiltByNixpkgsCompiler bash) ''
            # Don't patch #!/interpreter because it leads to retained
            # dependencies on the bootstrapTools in the final stdenv.
            dontPatchShebangs=1
          ''
          + ''
            ${commonPreHook}
            ${extraPreHook}
          ''
          + lib.optionalString (prevStage.darwin ? locale) ''
            export PATH_LOCALE=${prevStage.darwin.locale}/share/locale
          '';

        shell = bash + "/bin/bash";
        initialPath = [
          bash
          prevStage.file
          bootstrapTools
        ];

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
        overrides =
          self: super:
          (overrides self super)
          // {
            fetchurl = thisStdenv.fetchurlBoot;
            fetchpatch = super.fetchpatch.override { inherit (self) fetchurl; };
            fetchzip = super.fetchzip.override { inherit (self) fetchurl; };
          };
      };

    in
    {
      inherit config overlays;
      stdenv = thisStdenv;
    };

  # Dependencies - these are packages that are rebuilt together in groups. Defining them here ensures they are
  # asserted and overlayed together. It also removes a lot of clutter from the stage definitions.
  #
  # When multiple dependency sets share a dependency, it should be put in the one that will be (re)built first.
  # That makes sure everything else will share the same dependency in the final stdenv.

  allDeps =
    checkFn: sets:
    let
      sets' = mergeDisjointAttrs sets;
      result = lib.all checkFn (lib.attrValues sets');
      resultDetails = lib.mapAttrs (_: checkFn) sets';
    in
    lib.traceIf (!result) (lib.deepSeq resultDetails resultDetails) result;

  # These packages are built in stage 1 then never built again. They must not be included in the final overlay
  # or as dependencies to packages that are in the final overlay. They are mostly tools used as native build inputs.
  # Any libraries in the list must only be used as dependencies of packages in this list.
  stage1Packages = prevStage: {
    inherit (prevStage)
      atf
      autoconf
      automake
      bison
      bmake
      brotli
      cmake
      cpio
      cyrus_sasl
      ed
      expat
      flex
      gettext
      groff
      jq
      kyua
      libedit
      libtool
      m4
      meson
      ninja
      openldap
      openssh
      patchutils
      pbzx
      perl
      pkg-config
      python3
      python3Minimal
      scons
      serf
      sqlite
      subversion
      texinfo
      unzip
      which
      ;
  };

  # These packages include both the core bintools (other than LLVM) packages as well as their dependencies.
  bintoolsPackages = prevStage: {
    inherit (prevStage)
      cctools
      ld64
      bzip2
      coreutils
      gmp
      gnugrep
      libtapi
      openssl
      pcre2
      xar
      xz
      ;
  };

  darwinPackages = prevStage: { inherit (prevStage.darwin) sigtool; };
  darwinPackagesNoCC = prevStage: {
    inherit (prevStage.darwin)
      binutils
      binutils-unwrapped
      libSystem
      locale
      ;
  };

  # These packages are not allowed to be used in the Darwin bootstrap
  disallowedPackages = prevStage: { inherit (prevStage) binutils-unwrapped curl; };

  # LLVM tools packages are staged separately (xclang, stage3) from LLVM libs (xclang).
  llvmLibrariesPackages = prevStage: { inherit (prevStage.llvmPackages) compiler-rt libcxx; };
  llvmLibrariesDeps = _: { };

  llvmToolsPackages = prevStage: {
    inherit (prevStage.llvmPackages)
      clang-unwrapped
      libclang
      libllvm
      lld
      llvm
      llvm-manpages
      ;
  };

  llvmToolsDeps = prevStage: { inherit (prevStage) libffi; };

  # SDK packages include propagated packages and source release packages built during the bootstrap.
  sdkPackages = prevStage: {
    inherit (prevStage)
      bash
      libpng
      libxml2
      libxo
      ncurses
      openbsm
      openpam
      xcbuild
      zlib
      ;
  };
  sdkDarwinPackages = prevStage: {
    inherit (prevStage.darwin)
      Csu
      adv_cmds
      copyfile
      libiconv
      libresolv
      libsbuf
      libutil
      system_cmds
      ;
  };
  sdkPackagesNoCC = prevStage: { inherit (prevStage) apple-sdk; };

in
assert bootstrapTools.passthru.isFromBootstrapFiles or false; # sanity check
[
  (
    { }:
    {
      __raw = true;

      apple-sdk = null;

      cctools = null;
      ld64 = null;

      coreutils = null;
      file = null;
      gnugrep = null;

      pbzx = null;
      cpio = null;

      jq = null;

      darwin = {
        binutils = null;
        binutils-unwrapped = null;
        libSystem = null;
        sigtool = null;
      };

      llvmPackages = {
        clang-unwrapped = null;
        compiler-rt = null;
        libcxx = null;
        libllvm = null;
      };
    }
  )

  # Create a stage with the bootstrap tools. This will be used to build the subsequent stages and
  # build up the standard environment.
  #
  # Note: Each stage depends only on the the packages in `prevStage`. If a package is not to be
  # rebuilt, it should be passed through by inheriting it.
  (
    prevStage:
    stageFun prevStage {
      name = "bootstrap-stage0";

      overrides = self: super: {
        # We thread stage0's stdenv through under this name so downstream stages
        # can use it for wrapping gcc too. This way, downstream stages don't need
        # to refer to this stage directly, which violates the principle that each
        # stage should only access the stage that came before it.
        ccWrapperStdenv = self.stdenv;

        bash = bootstrapTools // {
          shellPath = "/bin/bash";
        };

        coreutils = bootstrapTools;
        cpio = bootstrapTools;
        file = null;
        gnugrep = bootstrapTools;
        pbzx = bootstrapTools;

        jq = null;

        cctools = bootstrapTools // {
          libtool = bootstrapTools;
          targetPrefix = "";
          version = "boot";
        };

        ld64 = bootstrapTools // {
          targetPrefix = "";
          version = "boot";
        };

        darwin = super.darwin.overrideScope (
          selfDarwin: superDarwin: {
            binutils = super.wrapBintoolsWith {
              name = "bootstrap-stage0-binutils-wrapper";

              nativeTools = false;
              nativeLibc = false;

              expand-response-params = "";
              libc = selfDarwin.libSystem;

              inherit lib;
              inherit (self) stdenvNoCC coreutils gnugrep;
              runtimeShell = self.stdenvNoCC.shell;

              bintools = selfDarwin.binutils-unwrapped;

              # Bootstrap tools cctools needs the hook and wrappers to make sure things are signed properly,
              # and additional linker flags to work around a since‐removed patch.
              # This can be dropped once the bootstrap tools cctools has been updated to 1010.6.
              extraBuildCommands = ''
                printf %s ${lib.escapeShellArg ''
                  extraBefore+=("-F$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks")
                  extraBefore+=("-L$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/lib")
                ''} >> $out/nix-support/add-local-ldflags-before.sh

                echo 'source ${selfDarwin.postLinkSignHook}' >> $out/nix-support/post-link-hook

                export signingUtils=${selfDarwin.signingUtils}

                wrap \
                  install_name_tool ${../../build-support/bintools-wrapper/darwin-install_name_tool-wrapper.sh} \
                  "${selfDarwin.binutils-unwrapped}/bin/install_name_tool"

                wrap \
                  strip ${../../build-support/bintools-wrapper/darwin-strip-wrapper.sh} \
                  "${selfDarwin.binutils-unwrapped}/bin/strip"
              '';
            };

            binutils-unwrapped =
              (superDarwin.binutils-unwrapped.override { enableManpages = false; }).overrideAttrs
                (old: {
                  version = "boot";
                  passthru = (old.passthru or { }) // {
                    isFromBootstrapFiles = true;
                  };
                });

            locale = self.stdenv.mkDerivation {
              name = "bootstrap-stage0-locale";
              buildCommand = ''
                mkdir -p $out/share/locale
              '';
            };

            sigtool = bootstrapTools;
          }
        );

        llvmPackages =
          super.llvmPackages
          // (
            let
              tools = super.llvmPackages.tools.extend (
                selfTools: _: {
                  libclang = self.stdenv.mkDerivation {
                    name = "bootstrap-stage0-clang";
                    version = "boot";
                    outputs = [
                      "out"
                      "lib"
                    ];
                    buildCommand = ''
                      mkdir -p $out/lib
                      ln -s $out $lib
                      ln -s ${bootstrapTools}/bin       $out/bin
                      ln -s ${bootstrapTools}/lib/clang $out/lib
                      ln -s ${bootstrapTools}/include   $out
                    '';
                    passthru = {
                      isFromBootstrapFiles = true;
                      hardeningUnsupportedFlags = [
                        "fortify3"
                        "shadowstack"
                        "stackclashprotection"
                        "zerocallusedregs"
                      ];
                    };
                  };
                  libllvm = self.stdenv.mkDerivation {
                    name = "bootstrap-stage0-llvm";
                    outputs = [
                      "out"
                      "lib"
                    ];
                    buildCommand = ''
                      mkdir -p $out/bin $out/lib
                      ln -s $out $lib
                      for tool in ${toString super.darwin.binutils-unwrapped.llvm_cmds}; do
                        cctoolsTool=''${tool//-/_}
                        toolsrc="${bootstrapTools}/bin/$cctoolsTool"
                        if [ -e "$toolsrc" ]; then
                          ln -s "$toolsrc" $out/bin/llvm-$tool
                        fi
                      done
                      ln -s ${bootstrapTools}/bin/dsymutil $out/bin/dsymutil
                      ln -s ${bootstrapTools}/lib/libLLVM* $out/lib
                    '';
                    passthru.isFromBootstrapFiles = true;
                  };
                  llvm-manpages = self.llvmPackages.libllvm;
                  lld = self.stdenv.mkDerivation {
                    name = "bootstrap-stage0-lld";
                    buildCommand = "";
                    passthru = {
                      isLLVM = true;
                      isFromBootstrapFiles = true;
                    };
                  };
                }
              );
              libraries = super.llvmPackages.libraries.extend (
                _: _: {
                  compiler-rt = self.stdenv.mkDerivation {
                    name = "bootstrap-stage0-compiler-rt";
                    buildCommand = ''
                      mkdir -p $out/lib $out/share
                      ln -s ${bootstrapTools}/lib/libclang_rt* $out/lib
                      ln -s ${bootstrapTools}/lib/darwin       $out/lib
                    '';
                    passthru.isFromBootstrapFiles = true;
                  };
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
                }
              );
            in
            { inherit tools libraries; } // tools // libraries
          );
      };

      extraPreHook = ''
        stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
      '';
    }
  )

  # This stage is primarily responsible for setting up versions of certain dependencies needed
  # by the rest of the build process. This stage also builds CF and Libsystem to simplify assertions
  # and assumptions for later by making sure both packages are present on x86_64-darwin and aarch64-darwin.
  (
    prevStage:
    # previous stage0 stdenv:
    assert allDeps isFromBootstrapFiles [
      (llvmToolsPackages prevStage)
      (llvmLibrariesPackages prevStage)
      {
        inherit (prevStage)
          bash
          cctools
          coreutils
          cpio
          gnugrep
          ld64
          pbzx
          ;
        inherit (prevStage.darwin) binutils-unwrapped sigtool;
      }
    ];

    assert allDeps isFromNixpkgs [
      (sdkPackagesNoCC prevStage)
      { inherit (prevStage.darwin) binutils libSystem; }
    ];

    stageFun prevStage {
      name = "bootstrap-stage1";

      overrides = self: super: {
        inherit (prevStage) ccWrapperStdenv cctools ld64;

        binutils-unwrapped = builtins.throw "nothing in the Darwin bootstrap should depend on GNU binutils";
        curl = builtins.throw "nothing in the Darwin bootstrap can depend on curl";

        # Use this stage’s CF to build CMake. It’s required but can’t be included in the stdenv.
        cmake = self.cmakeMinimal;

        # Use libiconvReal with gettext to break an infinite recursion.
        gettext = super.gettext.override { libiconv = super.libiconvReal; };

        # Disable tests because they use dejagnu, which fails to run.
        libffi = super.libffi.override { doCheck = false; };

        # Avoid pulling in a full python and its extra dependencies for the llvm/clang builds.
        libxml2 = super.libxml2.override { pythonSupport = false; };

        # Avoid pulling in openldap just to run Meson’s tests.
        meson = super.meson.overrideAttrs { doInstallCheck = false; };
        ninja = super.ninja.override { buildDocs = false; };

        # pkg-config builds glib, which checks for `arpa/nameser.h` and fails to build if it can’t find it.
        # libresolv is normally propagated by the SDK, but propagation is disabled early in the bootstrap.
        # Trying to add libresolv as a dependency causes an infinite recursion. Use pkgconf instead.
        pkg-config =
          (super.pkg-config.override {
            pkg-config = self.libpkgconf.override {
              removeReferencesTo = self.removeReferencesTo.override {
                # Avoid an infinite recursion by using the previous stage‘s sigtool.
                signingUtils = prevStage.darwin.signingUtils.override { inherit (prevStage.darwin) sigtool; };
              };
            };
            baseBinName = "pkgconf";
          }).overrideAttrs
            # Passthru the wrapped pkgconf’s stdenv to make the bootstrap assertions happy.
            (
              old: {
                passthru = old.passthru or { } // {
                  inherit (self) stdenv;
                };
              }
            );

        # Use a full Python for the bootstrap. This allows Meson to be built in stage 1 and makes it easier to build
        # packages that have Python dependencies.
        python3 = self.python3-bootstrap;
        python3-bootstrap = super.python3.override {
          self = self.python3-bootstrap;
          pythonAttr = "python3-bootstrap";
          enableLTO = false;
          # Workaround for ld64 crashes on x86_64-darwin. Remove after 11.0 is made the default.
          inherit (prevStage) apple-sdk_11;
        };

        scons = super.scons.override { python3Packages = self.python3.pkgs; };

        xar = super.xarMinimal;

        darwin = super.darwin.overrideScope (
          selfDarwin: superDarwin: {
            signingUtils = prevStage.darwin.signingUtils.override { inherit (selfDarwin) sigtool; };

            postLinkSignHook = prevStage.darwin.postLinkSignHook.override { inherit (selfDarwin) sigtool; };

            adv_cmds = superDarwin.adv_cmds.override {
              # Break an infinite recursion between CMake and libtapi. CMake requires adv_cmds.ps, and adv_cmds
              # requires a newer SDK that requires libtapi to build, which requires CMake.
              inherit (prevStage) apple-sdk_11;
            };

            # Rewrap binutils with the real libSystem
            binutils = superDarwin.binutils.override {
              inherit (self) coreutils;
              bintools = selfDarwin.binutils-unwrapped;
              libc = selfDarwin.libSystem;

              # Bootstrap tools cctools needs the hook and wrappers to make sure things are signed properly.
              # This can be dropped once the bootstrap tools cctools has been updated to 1010.6.
              extraBuildCommands = ''
                printf %s ${lib.escapeShellArg ''
                  extraBefore+=("-F$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks")
                  extraBefore+=("-L$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/lib")
                ''} >> $out/nix-support/add-local-ldflags-before.sh

                echo 'source ${selfDarwin.postLinkSignHook}' >> $out/nix-support/post-link-hook

                export signingUtils=${selfDarwin.signingUtils}

                wrap \
                  install_name_tool ${../../build-support/bintools-wrapper/darwin-install_name_tool-wrapper.sh} \
                  "${selfDarwin.binutils-unwrapped}/bin/install_name_tool"

                wrap \
                  strip ${../../build-support/bintools-wrapper/darwin-strip-wrapper.sh} \
                  "${selfDarwin.binutils-unwrapped}/bin/strip"
              '';
            };

            # Avoid building unnecessary Python dependencies due to building LLVM manpages.
            binutils-unwrapped = superDarwin.binutils-unwrapped.override {
              inherit (self) cctools ld64;
              enableManpages = false;
            };
          }
        );

        llvmPackages =
          let
            tools = super.llvmPackages.tools.extend (_: _: llvmToolsPackages prevStage);
            libraries = super.llvmPackages.libraries.extend (_: _: llvmLibrariesPackages prevStage);
          in
          super.llvmPackages // { inherit tools libraries; } // tools // libraries;
      };

      extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
        prevStage.updateAutotoolsGnuConfigScriptsHook
        prevStage.gnu-config
      ];

      extraPreHook = ''
        stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
      '';
    }
  )

  # First rebuild of LLVM. While this LLVM is linked to a bunch of junk from the bootstrap tools,
  # the compiler-rt, libc++, and libc++abi it produces are not. The compiler will be
  # rebuilt in a later stage, but those libraries will be used in the final stdenv.
  (
    prevStage:
    # previous stage1 stdenv:
    assert allDeps isFromBootstrapFiles [
      (llvmLibrariesPackages prevStage)
      (llvmToolsPackages prevStage)
      { inherit (prevStage) ld64; }
    ];

    assert allDeps isBuiltByBootstrapFilesCompiler [
      (stage1Packages prevStage)
      (darwinPackages prevStage)
      (llvmLibrariesDeps prevStage)
      (llvmToolsDeps prevStage)
      (sdkPackages prevStage)
      (sdkDarwinPackages prevStage)
    ];

    assert allDeps isFromNixpkgs [
      (darwinPackagesNoCC prevStage)
      (sdkPackagesNoCC prevStage)
    ];

    stageFun prevStage {
      name = "bootstrap-stage-xclang";

      overrides =
        self: super:
        mergeDisjointAttrs [
          (stage1Packages prevStage)
          (disallowedPackages prevStage)
          # Only cctools and ld64 are rebuilt from `bintoolsPackages` to avoid rebuilding their dependencies
          # again in this stage after building them in stage 1.
          (lib.filterAttrs (name: _: name != "ld64" && name != "cctools") (bintoolsPackages prevStage))
          (llvmToolsDeps prevStage)
          (sdkPackages prevStage)
          (sdkPackagesNoCC prevStage)
          {
            inherit (prevStage) ccWrapperStdenv;

            # Disable ld64’s install check phase because the required LTO libraries are not built yet.
            ld64 = super.ld64.overrideAttrs { doInstallCheck = false; };

            darwin = super.darwin.overrideScope (
              selfDarwin: superDarwin:
              darwinPackages prevStage
              // sdkDarwinPackages prevStage
              // {
                inherit (prevStage.darwin) libSystem;
                binutils-unwrapped = superDarwin.binutils-unwrapped.override { enableManpages = false; };
              }
            );
          }
        ];

      extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
        prevStage.updateAutotoolsGnuConfigScriptsHook
        prevStage.gnu-config
      ];

      extraPreHook = ''
        stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
      '';
    }
  )

  # This stage rebuilds the SDK. It also rebuilds bash, which will be needed in later stages
  # to use in patched shebangs (e.g., to make sure `icu-config` uses bash from nixpkgs).
  (
    prevStage:
    # previous stage-xclang stdenv:
    assert allDeps isBuiltByBootstrapFilesCompiler [
      (stage1Packages prevStage)
      (bintoolsPackages prevStage)
      (darwinPackages prevStage)
      (llvmToolsDeps prevStage)
      (llvmToolsPackages prevStage)
      (sdkPackages prevStage)
      (sdkDarwinPackages prevStage)
    ];

    assert allDeps isBuiltByNixpkgsCompiler [
      (llvmLibrariesDeps prevStage)
      (llvmLibrariesPackages prevStage)
    ];

    assert allDeps isFromNixpkgs [
      (darwinPackagesNoCC prevStage)
      (sdkPackagesNoCC prevStage)
    ];

    stageFun prevStage {
      name = "bootstrap-stage2";

      overrides =
        self: super:
        mergeDisjointAttrs [
          (stage1Packages prevStage)
          (disallowedPackages prevStage)
          (bintoolsPackages prevStage)
          (llvmLibrariesDeps prevStage)
          (llvmToolsDeps prevStage)
          {
            inherit (prevStage) ccWrapperStdenv;

            # Avoid an infinite recursion due to the SDK’s including ncurses, which depends on bash in its `dev` output.
            bash = super.bash.override { stdenv = self.darwin.bootstrapStdenv; };

            # Avoid pulling in a full python and its extra dependencies for the llvm/clang builds.
            libxml2 = super.libxml2.override { pythonSupport = false; };

            # Use Bash from this stage to avoid propagating Bash from a previous stage to the final stdenv.
            ncurses = super.ncurses.override {
              stdenv = self.darwin.bootstrapStdenv.override { shell = lib.getExe self.bash; };
            };

            darwin = super.darwin.overrideScope (
              selfDarwin: superDarwin:
              darwinPackages prevStage
              // {
                inherit (prevStage.darwin) binutils-unwrapped;
                # Rewrap binutils so it uses the rebuilt Libsystem.
                binutils = superDarwin.binutils.override {
                  inherit (prevStage) expand-response-params;
                  libc = selfDarwin.libSystem;
                };
              }
            );

            llvmPackages =
              let
                tools = super.llvmPackages.tools.extend (
                  _: _: llvmToolsPackages prevStage // { inherit (prevStage.llvmPackages) clangNoCompilerRtWithLibc; }
                );
                libraries = super.llvmPackages.libraries.extend (_: _: llvmLibrariesPackages prevStage);
              in
              super.llvmPackages // { inherit tools libraries; } // tools // libraries;
          }
        ];

      extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
        prevStage.updateAutotoolsGnuConfigScriptsHook
        prevStage.gnu-config
      ];

      extraPreHook = ''
        stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
      '';
    }
  )

  # Rebuild LLVM with LLVM. This stage also rebuilds certain dependencies needed by LLVM.
  # The SDK (but not its other inputs) is also rebuilt this stage to pick up the rebuilt cctools for `libtool`.
  (
    prevStage:
    # previous stage2 stdenv:
    assert allDeps isBuiltByBootstrapFilesCompiler [
      (stage1Packages prevStage)
      (bintoolsPackages prevStage)
      (darwinPackages prevStage)
      (llvmToolsPackages prevStage)
      (llvmToolsDeps prevStage)
    ];

    assert allDeps isBuiltByNixpkgsCompiler [
      (llvmLibrariesDeps prevStage)
      (llvmLibrariesPackages prevStage)
      (sdkPackages prevStage)
      (sdkDarwinPackages prevStage)
    ];

    assert allDeps isFromNixpkgs [
      (darwinPackagesNoCC prevStage)
      (sdkPackagesNoCC prevStage)
    ];

    stageFun prevStage {
      name = "bootstrap-stage3";

      overrides =
        self: super:
        mergeDisjointAttrs [
          (stage1Packages prevStage)
          (disallowedPackages prevStage)
          (llvmLibrariesDeps prevStage)
          (sdkPackages prevStage)
          {
            inherit (prevStage) ccWrapperStdenv;

            # Disable tests because they use dejagnu, which fails to run.
            libffi = super.libffi.override { doCheck = false; };

            xar = super.xarMinimal;

            darwin = super.darwin.overrideScope (
              selfDarwin: superDarwin:
              darwinPackages prevStage
              // sdkDarwinPackages prevStage
              # Rebuild darwin.binutils with the new LLVM, so only inherit libSystem from the previous stage.
              // {
                inherit (prevStage.darwin) libSystem;
              }
            );

            llvmPackages =
              let
                tools = super.llvmPackages.tools.extend (
                  _: superTools: {
                    # darwin.binutils-unwrapped needs to build the LLVM man pages, which requires a lot of Python stuff
                    # that ultimately ends up depending on git. Fortunately, the git dependency is only for check
                    # inputs. The following set of overrides allow the LLVM documentation to be built without
                    # pulling curl (and other packages like ffmpeg) into the stdenv bootstrap.
                    #
                    # However, even without darwin.binutils-unwrapped, this has to be overriden in the LLVM package set
                    # because otherwise llvmPackages.llvm-manpages on its own is broken.
                    llvm-manpages = superTools.llvm-manpages.override {
                      python3Packages = self.python3.pkgs.overrideScope (
                        _: superPython: {
                          hatch-vcs = superPython.hatch-vcs.overrideAttrs { doInstallCheck = false; };
                          markdown-it-py = superPython.markdown-it-py.overrideAttrs { doInstallCheck = false; };
                          mdit-py-plugins = superPython.mdit-py-plugins.overrideAttrs { doInstallCheck = false; };
                          myst-parser = superPython.myst-parser.overrideAttrs { doInstallCheck = false; };
                        }
                      );
                    };
                  }
                );
                libraries = super.llvmPackages.libraries.extend (_: _: llvmLibrariesPackages prevStage);
              in
              super.llvmPackages // { inherit tools libraries; } // tools // libraries;
          }
        ];

      extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
        prevStage.updateAutotoolsGnuConfigScriptsHook
        prevStage.gnu-config
      ];

      extraPreHook = ''
        stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
      '';
    }
  )

  # Construct a standard environment with the new clang. Also use the new compiler to rebuild
  # everything that will be part of the final stdenv and isn’t required by it, CF, or Libsystem.
  (
    prevStage:
    # previous stage3 stdenv:
    assert allDeps isBuiltByBootstrapFilesCompiler [
      (stage1Packages prevStage)
      (darwinPackages prevStage)
    ];

    assert allDeps isBuiltByNixpkgsCompiler [
      (bintoolsPackages prevStage)
      (llvmLibrariesDeps prevStage)
      (llvmLibrariesPackages prevStage)
      (llvmToolsDeps prevStage)
      (llvmToolsPackages prevStage)
      (sdkPackages prevStage)
      (sdkDarwinPackages prevStage)
    ];

    assert allDeps isFromNixpkgs [
      (darwinPackagesNoCC prevStage)
      (sdkPackagesNoCC prevStage)
    ];

    stageFun prevStage {
      name = "bootstrap-stage4";

      overrides =
        self: super:
        mergeDisjointAttrs [
          (bintoolsPackages prevStage)
          (disallowedPackages prevStage)
          (llvmLibrariesDeps prevStage)
          (llvmToolsDeps prevStage)
          (sdkPackages prevStage)
          (sdkPackagesNoCC prevStage)
          {
            inherit (prevStage) ccWrapperStdenv;

            # Rebuild locales and sigtool with the new clang.
            darwin = super.darwin.overrideScope (
              _: superDarwin:
              sdkDarwinPackages prevStage
              // {
                inherit (prevStage.darwin) binutils-unwrapped libSystem;
                binutils = superDarwin.binutils.override {
                  # Build expand-response-params with last stage like below
                  inherit (prevStage) expand-response-params;
                };
                # Avoid rebuilding bmake (and Python) just for locales
                locale = superDarwin.locale.override { inherit (prevStage) bmake; };
              }
            );

            llvmPackages =
              let
                tools = super.llvmPackages.tools.extend (
                  _: _:
                  llvmToolsPackages prevStage
                  // {
                    libcxxClang = super.wrapCCWith rec {
                      nativeTools = false;
                      nativeLibc = false;

                      inherit (prevStage) expand-response-params;

                      extraPackages = [ self.llvmPackages.compiler-rt ];

                      extraBuildCommands = ''
                        rsrc="$out/resource-root"
                        mkdir "$rsrc"
                        ln -s "${lib.getLib cc}/lib/clang/${lib.versions.major (lib.getVersion cc)}/include" "$rsrc"
                        echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
                        ln -s "${prevStage.llvmPackages.compiler-rt.out}/lib" "$rsrc/lib"
                        ln -s "${prevStage.llvmPackages.compiler-rt.out}/share" "$rsrc/share"
                      '';

                      cc = self.llvmPackages.clang-unwrapped;
                      bintools = self.darwin.binutils;

                      isClang = true;
                      libc = self.darwin.libSystem;
                      inherit (self.llvmPackages) libcxx;

                      inherit lib;
                      inherit (self)
                        stdenvNoCC
                        coreutils
                        gnugrep
                        runtimeShell
                        ;
                    };
                  }
                );
                libraries = super.llvmPackages.libraries.extend (_: _: llvmLibrariesPackages prevStage);
              in
              super.llvmPackages // { inherit tools libraries; } // tools // libraries;
          }
        ];

      extraNativeBuildInputs = lib.optionals localSystem.isAarch64 [
        prevStage.updateAutotoolsGnuConfigScriptsHook
        prevStage.gnu-config
      ];

      extraPreHook = ''
        stripDebugFlags="-S" # llvm-strip does not support "-p" for Mach-O
      '';
    }
  )

  # Construct the final stdenv. The version of LLVM provided should match the one defined in
  # `all-packages.nix` for Darwin. Nothing should depend on the bootstrap tools or originate from
  # the bootstrap tools.
  #
  # When updating the Darwin stdenv, make sure that the result has no dependency (`nix-store -qR`)
  # on `bootstrapTools` or the binutils built in stage 1.
  (
    prevStage:
    # previous stage4 stdenv:

    assert allDeps isBuiltByNixpkgsCompiler [
      (lib.filterAttrs (_: pkg: lib.getName pkg != "pkg-config-wrapper") (stage1Packages prevStage)) # pkg-config is a wrapper
      (bintoolsPackages prevStage)
      (darwinPackages prevStage)
      (llvmLibrariesDeps prevStage)
      (llvmLibrariesPackages prevStage)
      (llvmToolsDeps prevStage)
      (llvmToolsPackages prevStage)
      (sdkPackages prevStage)
      (sdkDarwinPackages prevStage)
      { inherit (prevStage.pkg-config) pkg-config; }
    ];

    assert allDeps isFromNixpkgs [
      (darwinPackagesNoCC prevStage)
      (sdkPackagesNoCC prevStage)
    ];

    let
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
        ];

        extraBuildInputs = [ prevStage.apple-sdk ];

        inherit cc;

        shell = cc.shell;

        inherit (prevStage.stdenv) fetchurlBoot;

        extraAttrs = {
          inherit bootstrapTools;
          libc = prevStage.darwin.libSystem;
          shellPackage = prevStage.bash;
        };

        disallowedRequisites = [ bootstrapTools.out ];

        allowedRequisites =
          (
            with prevStage;
            [
              apple-sdk
              bash
              bzip2.bin
              bzip2.out
              cc.expand-response-params
              cctools
              cctools.libtool
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
              ld64.lib
              ld64.out
              libffi.out
              libtapi.out
              libunistring.out
              libxml2.out
              ncurses.dev
              ncurses.man
              ncurses.out
              openbsm
              openpam
              openssl.out
              patch
              xar.lib
              xcbuild
              xcbuild.xcrun
              xz.bin
              xz.out
              zlib.dev
              zlib.out
            ]
            ++ apple-sdk.propagatedBuildInputs
          )
          ++ lib.optionals localSystem.isAarch64 [
            prevStage.updateAutotoolsGnuConfigScriptsHook
            prevStage.gnu-config
          ]
          ++ lib.optionals localSystem.isx86_64 [ prevStage.darwin.Csu ]
          ++ (with prevStage.darwin; [
            libiconv.out
            libresolv.out
            libsbuf.out
            libSystem
            locale
          ])
          ++ (with prevStage.llvmPackages; [
            bintools-unwrapped
            clang-unwrapped
            (lib.getLib clang-unwrapped)
            compiler-rt
            compiler-rt.dev
            libcxx
            libcxx.dev
            lld
            llvm
            llvm.lib
          ]);

        __stdenvImpureHostDeps = commonImpureHostDeps;
        __extraImpureHostDeps = commonImpureHostDeps;

        overrides =
          self: super:
          mergeDisjointAttrs [
            (llvmLibrariesDeps prevStage)
            (llvmToolsDeps prevStage)
            (sdkPackages prevStage)
            (sdkPackagesNoCC prevStage)
            {
              inherit (prevStage)
                diffutils
                ed
                file
                findutils
                gawk
                gettext
                gnumake
                gnused
                gnutar
                gzip
                patch
                ;

              # TODO: Simplify when dropping support for macOS < 11.
              "apple-sdk_${builtins.replaceStrings [ "." ] [ "_" ] sdkMajorVersion}" = self.apple-sdk;

              darwin = super.darwin.overrideScope (
                _: _:
                sdkDarwinPackages prevStage
                // {
                  inherit (prevStage.darwin) libSystem locale sigtool;
                }
                // lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) {
                  inherit (prevStage.darwin) binutils binutils-unwrapped;
                }
              );
            }
            (lib.optionalAttrs (super.stdenv.targetPlatform == localSystem) (
              (bintoolsPackages prevStage)
              // {
                inherit (prevStage.llvmPackages) clang;
                # Need to get rid of these when cross-compiling.
                "llvmPackages_${lib.versions.major prevStage.llvmPackages.release_version}" =
                  let
                    llvmVersion = lib.versions.major prevStage.llvmPackages.release_version;
                    tools = super."llvmPackages_${llvmVersion}".tools.extend (
                      _: _: llvmToolsPackages prevStage // { inherit (prevStage.llvmPackages) clang; }
                    );
                    libraries = super."llvmPackages_${llvmVersion}".libraries.extend (
                      _: _: llvmLibrariesPackages prevStage
                    );
                  in
                  super."llvmPackages_${llvmVersion}" // { inherit tools libraries; } // tools // libraries;
              }
            ))
          ];
      };
    }
  )

  # This "no-op" stage is just a place to put the assertions about the final stage.
  (
    prevStage:
    # previous final stage stdenv:
    assert isBuiltByNixpkgsCompiler prevStage.cctools;
    assert isBuiltByNixpkgsCompiler prevStage.ld64;
    assert isBuiltByNixpkgsCompiler prevStage.darwin.sigtool;

    assert isFromNixpkgs prevStage.darwin.libSystem;
    assert isFromNixpkgs prevStage.darwin.binutils-unwrapped;

    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.clang-unwrapped;
    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.libllvm;
    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.libcxx;
    assert isBuiltByNixpkgsCompiler prevStage.llvmPackages.compiler-rt;

    # Make sure these evaluate since they were disabled explicitly in the bootstrap.
    assert isBuiltByNixpkgsCompiler prevStage.binutils-unwrapped;
    assert isFromNixpkgs prevStage.binutils-unwrapped.src;
    assert isBuiltByNixpkgsCompiler prevStage.curl;

    # libiconv should be an alias for darwin.libiconv
    assert prevStage.libiconv == prevStage.darwin.libiconv;

    {
      inherit (prevStage) config overlays stdenv;
    }
  )
]
