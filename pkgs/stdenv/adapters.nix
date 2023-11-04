/* This file contains various functions that take a stdenv and return
   a new stdenv with different behaviour, e.g. using a different C
   compiler. */

{ lib, pkgs, config }:

let
  # N.B. Keep in sync with default arg for stdenv/generic.
  defaultMkDerivationFromStdenv = import ./generic/make-derivation.nix { inherit lib config; };

  # Low level function to help with overriding `mkDerivationFromStdenv`. One
  # gives it the old stdenv arguments and a "continuation" function, and
  # underneath the final stdenv argument it yields to the continuation to do
  # whatever it wants with old `mkDerivation` (old `mkDerivationFromStdenv`
  # applied to the *new, final* stdenv) provided for convenience.
  withOldMkDerivation = stdenvSuperArgs: k: stdenvSelf: let
    mkDerivationFromStdenv-super = stdenvSuperArgs.mkDerivationFromStdenv or defaultMkDerivationFromStdenv;
    mkDerivationSuper = mkDerivationFromStdenv-super stdenvSelf;
  in
    k stdenvSelf mkDerivationSuper;

  # Wrap the original `mkDerivation` providing extra args to it.
  extendMkDerivationArgs = old: f: withOldMkDerivation old (_: mkDerivationSuper: args:
    (mkDerivationSuper args).overrideAttrs f);

  # Wrap the original `mkDerivation` transforming the result.
  overrideMkDerivationResult = old: f: withOldMkDerivation old (_: mkDerivationSuper: args:
    f (mkDerivationSuper args));
in

rec {


  # Override the compiler in stdenv for specific packages.
  overrideCC = stdenv: cc: stdenv.override { allowedRequisites = null; cc = cc; };


  # Add some arbitrary packages to buildInputs for specific packages.
  # Used to override packages in stdenv like Make.  Should not be used
  # for other dependencies.
  overrideInStdenv = stdenv: pkgs:
    stdenv.override (prev: { allowedRequisites = null; extraBuildInputs = (prev.extraBuildInputs or []) ++ pkgs; });


  # Override the libc++ dynamic library used in the stdenv to use the one from the platform’s
  # default stdenv. This allows building packages and linking dependencies with different
  # compiler versions while still using the same libc++ implementation for compatibility.
  #
  # Note that this adapter still uses the headers from the new stdenv’s libc++. This is necessary
  # because older compilers may not be able to parse the headers from the default stdenv’s libc++.
  overrideLibcxx = stdenv:
    assert stdenv.cc.libcxx != null;
    let
      llvmLibcxxVersion = lib.getVersion llvmLibcxx;
      stdenvLibcxxVersion = lib.getVersion stdenvLibcxx;

      stdenvLibcxx = pkgs.stdenv.cc.libcxx;
      stdenvCxxabi = pkgs.stdenv.cc.libcxx.cxxabi;

      llvmLibcxx = stdenv.cc.libcxx;
      llvmCxxabi = stdenv.cc.libcxx.cxxabi;

      libcxx = pkgs.runCommand "${stdenvLibcxx.name}-${llvmLibcxxVersion}" {
        outputs = [ "out" "dev" ];
        inherit cxxabi;
        isLLVM = true;
      } ''
        mkdir -p "$dev/nix-support"
        ln -s '${stdenvLibcxx}' "$out"
        echo '${stdenvLibcxx}' > "$dev/nix-support/propagated-build-inputs"
        ln -s '${lib.getDev llvmLibcxx}/include' "$dev/include"
      '';

      cxxabi = pkgs.runCommand "${stdenvCxxabi.name}-${llvmLibcxxVersion}" {
        outputs = [ "out" "dev" ];
        inherit (stdenvCxxabi) libName;
      } ''
        mkdir -p "$dev/nix-support"
        ln -s '${stdenvCxxabi}' "$out"
        echo '${stdenvCxxabi}' > "$dev/nix-support/propagated-build-inputs"
        ln -s '${lib.getDev llvmCxxabi}/include' "$dev/include"
      '';
    in
    overrideCC stdenv (stdenv.cc.override {
      inherit libcxx;
      extraPackages = [ cxxabi pkgs.pkgsTargetTarget."llvmPackages_${lib.versions.major llvmLibcxxVersion}".compiler-rt ];
    });

  # Override the setup script of stdenv.  Useful for testing new
  # versions of the setup script without causing a rebuild of
  # everything.
  #
  # Example:
  #   randomPkg = import ../bla { ...
  #     stdenv = overrideSetup stdenv ../stdenv/generic/setup-latest.sh;
  #   };
  overrideSetup = stdenv: setupScript: stdenv.override { inherit setupScript; };


  # Return a modified stdenv that tries to build statically linked
  # binaries.
  makeStaticBinaries = stdenv0:
    stdenv0.override (old: {
      mkDerivationFromStdenv = withOldMkDerivation old (stdenv: mkDerivationSuper: args:
      if stdenv.hostPlatform.isDarwin
      then throw "Cannot build fully static binaries on Darwin/macOS"
      else (mkDerivationSuper args).overrideAttrs (args: {
        NIX_CFLAGS_LINK = toString (args.NIX_CFLAGS_LINK or "") + " -static";
      } // lib.optionalAttrs (!(args.dontAddStaticConfigureFlags or false)) {
        configureFlags = (args.configureFlags or []) ++ [
          "--disable-shared" # brrr...
        ];
        cmakeFlags = (args.cmakeFlags or []) ++ ["-DCMAKE_SKIP_INSTALL_RPATH=On"];
      }));
    } // lib.optionalAttrs (stdenv0.hostPlatform.libc == "glibc") {
      extraBuildInputs = (old.extraBuildInputs or []) ++ [
        pkgs.glibc.static
      ];
    });


  # Return a modified stdenv that builds static libraries instead of
  # shared libraries.
  makeStaticLibraries = stdenv:
    stdenv.override (old: {
      mkDerivationFromStdenv = extendMkDerivationArgs old (args: {
        dontDisableStatic = true;
      } // lib.optionalAttrs (!(args.dontAddStaticConfigureFlags or false)) {
        configureFlags = (args.configureFlags or []) ++ [
          "--enable-static"
          "--disable-shared"
        ];
        cmakeFlags = (args.cmakeFlags or []) ++ [ "-DBUILD_SHARED_LIBS:BOOL=OFF" ];
        mesonFlags = (args.mesonFlags or []) ++ [ "-Ddefault_library=static" ];
      });
    });

  # Best effort static binaries. Will still be linked to libSystem,
  # but more portable than Nix store binaries.
  makeStaticDarwin = stdenv: stdenv.override (old: {
    # extraBuildInputs are dropped in cross.nix, but darwin still needs them
    extraBuildInputs = [ pkgs.buildPackages.darwin.CF ];
    mkDerivationFromStdenv = withOldMkDerivation old (stdenv: mkDerivationSuper: args:
    (mkDerivationSuper args).overrideAttrs (finalAttrs: {
      NIX_CFLAGS_LINK = toString (finalAttrs.NIX_CFLAGS_LINK or "")
        + lib.optionalString (stdenv.cc.isGNU or false) " -static-libgcc";
      nativeBuildInputs = (finalAttrs.nativeBuildInputs or [])
        ++ lib.optionals stdenv.hasCC [
          (pkgs.buildPackages.makeSetupHook {
            name = "darwin-portable-libSystem-hook";
            substitutions = {
              libsystem = "${stdenv.cc.libc}/lib/libSystem.B.dylib";
              targetPrefix = stdenv.cc.bintools.targetPrefix;
            };
          } ./darwin/portable-libsystem.sh)
        ];
    }));
  });

  # Puts all the other ones together
  makeStatic = stdenv: lib.foldl (lib.flip lib.id) stdenv (
    lib.optional stdenv.hostPlatform.isDarwin makeStaticDarwin

    ++ [ makeStaticLibraries propagateBuildInputs ]

    # Apple does not provide a static version of libSystem or crt0.o
    # So we can’t build static binaries without extensive hacks.
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) makeStaticBinaries
  );


  /* Modify a stdenv so that all buildInputs are implicitly propagated to
     consuming derivations
  */
  propagateBuildInputs = stdenv:
    stdenv.override (old: {
      mkDerivationFromStdenv = extendMkDerivationArgs old (args: {
        propagatedBuildInputs = (args.propagatedBuildInputs or []) ++ (args.buildInputs or []);
        buildInputs = [];
      });
    });


  /* Modify a stdenv so that the specified attributes are added to
     every derivation returned by its mkDerivation function.

     Example:
       stdenvNoOptimise =
         addAttrsToDerivation
           { env.NIX_CFLAGS_COMPILE = "-O0"; }
           stdenv;
  */
  addAttrsToDerivation = extraAttrs: stdenv: stdenv.override (old: {
    mkDerivationFromStdenv = extendMkDerivationArgs old (_: extraAttrs);
  });


  /* Use the trace output to report all processed derivations with their
     license name.
  */
  traceDrvLicenses = stdenv:
    stdenv.override (old: {
      mkDerivationFromStdenv = overrideMkDerivationResult (pkg:
        let
          printDrvPath = val: let
            drvPath = builtins.unsafeDiscardStringContext pkg.drvPath;
            license = pkg.meta.license or null;
          in
            builtins.trace "@:drv:${toString drvPath}:${builtins.toString license}:@" val;
        in pkg // {
          outPath = printDrvPath pkg.outPath;
          drvPath = printDrvPath pkg.drvPath;
        });
    });


  /* Modify a stdenv so that it produces debug builds; that is,
     binaries have debug info, and compiler optimisations are
     disabled. */
  keepDebugInfo = stdenv:
    stdenv.override (old: {
      mkDerivationFromStdenv = extendMkDerivationArgs old (args: {
        dontStrip = true;
        env = (args.env or {}) // { NIX_CFLAGS_COMPILE = toString (args.env.NIX_CFLAGS_COMPILE or "") + " -ggdb -Og"; };
      });
    });


  /* Modify a stdenv so that it uses the Gold linker. */
  useGoldLinker = stdenv:
    stdenv.override (old: {
      mkDerivationFromStdenv = extendMkDerivationArgs old (args: {
        NIX_CFLAGS_LINK = toString (args.NIX_CFLAGS_LINK or "") + " -fuse-ld=gold";
      });
    });

  useMoldLinker = stdenv: let
    bintools = stdenv.cc.bintools.override {
      extraBuildCommands = ''
        wrap ${stdenv.cc.bintools.targetPrefix}ld.mold ${../build-support/bintools-wrapper/ld-wrapper.sh} ${pkgs.mold}/bin/ld.mold
        wrap ${stdenv.cc.bintools.targetPrefix}ld ${../build-support/bintools-wrapper/ld-wrapper.sh} ${pkgs.mold}/bin/ld.mold
      '';
    };
  in stdenv.override (old: {
    allowedRequisites = null;
    cc = stdenv.cc.override { inherit bintools; };
    # gcc >12.1.0 supports '-fuse-ld=mold'
    # the wrap ld above in bintools supports gcc <12.1.0 and shouldn't harm >12.1.0
    # https://github.com/rui314/mold#how-to-use
    } // lib.optionalAttrs (stdenv.cc.isClang || (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12")) {
    mkDerivationFromStdenv = extendMkDerivationArgs old (args: {
      NIX_CFLAGS_LINK = toString (args.NIX_CFLAGS_LINK or "") + " -fuse-ld=mold";
    });
  });


  /* Modify a stdenv so that it builds binaries optimized specifically
     for the machine they are built on.

     WARNING: this breaks purity! */
  impureUseNativeOptimizations = stdenv:
    stdenv.override (old: {
      mkDerivationFromStdenv = extendMkDerivationArgs old (args: {
        env = (args.env or {}) // { NIX_CFLAGS_COMPILE = toString (args.env.NIX_CFLAGS_COMPILE or "") + " -march=native"; };

        NIX_ENFORCE_NO_NATIVE = false;

        preferLocalBuild = true;
        allowSubstitutes = false;
      });
    });


  /* Modify a stdenv so that it builds binaries with the specified list of
     compilerFlags appended and passed to the compiler.

     This example would recompile every derivation on the system with
     -funroll-loops and -O3 passed to each gcc invocation.

     Example:
       nixpkgs.overlays = [
         (self: super: {
           stdenv = super.withCFlags [ "-funroll-loops" "-O3" ] super.stdenv;
         })
       ];
  */
  withCFlags = compilerFlags: stdenv:
    stdenv.override (old: {
      mkDerivationFromStdenv = extendMkDerivationArgs old (args: {
        env = (args.env or {}) // { NIX_CFLAGS_COMPILE = toString (args.env.NIX_CFLAGS_COMPILE or "") + " ${toString compilerFlags}"; };
      });
    });

  # Overriding the SDK changes the Darwin SDK used to build the package, which:
  # * Ensures that the compiler and bintools have the correct Libsystem version; and
  # * Replaces any SDK references with those in the SDK corresponding to the requested SDK version.
  #
  # `sdkVersion` can be any of the following:
  # * A version string indicating the requested SDK version; or
  # * An attrset consisting of either or both of the following fields: darwinSdkVersion and darwinMinVersion.
  overrideSDK = stdenv: sdkVersion:
    let
      inherit (
        { inherit (stdenv.hostPlatform) darwinMinVersion darwinSdkVersion; }
        // (if lib.isAttrs sdkVersion then sdkVersion else { darwinSdkVersion = sdkVersion; })
      ) darwinMinVersion darwinSdkVersion;

      sdk = pkgs.darwin."apple_sdk_${lib.replaceStrings [ "." ] [ "_" ] darwinSdkVersion}";
      # TODO: Make this unconditional after #229210 has been merged,
      # and the 10.12 SDK is updated to follow the new structure.
      Libsystem = if darwinSdkVersion == "10.12" then pkgs.darwin.Libsystem else sdk.Libsystem;

      replacePropagatedFrameworks = pkg:
        let
          propagatedInputs = pkg.propagatedBuildInputs;
          mappedInputs = map mapPackageToSDK propagatedInputs;

          env = {
            inherit (pkg) outputs;
            # Map old frameworks to new ones and the package’s outputs to their original outPaths.
            # Also map any packages that have propagated frameworks to their proxy packages using
            # the requested SDK version. These mappings are rendered into tab-separated files to be
            # parsed and read back with `read`.
            dependencies = lib.concatMapStrings (pair: "${pair.fst}\t${pair.snd}\n") (lib.zipLists propagatedInputs mappedInputs);
            pkgOutputs = lib.concatMapStrings (output: "${output}\t${(lib.getOutput output pkg).outPath}\n") pkg.outputs;
            passAsFile = [ "dependencies" "pkgOutputs" ];
          };
        in
        # Only remap the package’s propagated inputs if there are any and if any of them were themselves remapped.
        if lib.length propagatedInputs > 0 && propagatedInputs != mappedInputs
          then pkgs.runCommand pkg.name env ''
            # Iterate over the outputs in the package being replaced to make sure the proxy is
            # a fully functional replacement. This is like `symlinkJoin` except for outputs and
            # the contents of `nix-support`, which will be customized for the requested SDK.
            while IFS=$'\t\n' read -r outputName pkgOutputPath; do
              mkdir -p "''${!outputName}"

              for targetPath in "$pkgOutputPath"/*; do
                targetName=$(basename "$targetPath")

                # `nix-support` is special-cased because any propagated inputs need their SDK
                # frameworks replaced with those from the requested SDK.
                if [ "$targetName" == "nix-support" ]; then
                  mkdir "''${!outputName}/nix-support"

                  for file in "$targetPath"/*; do
                    fileName=$(basename "$file")

                    if [ "$fileName" == "propagated-build-inputs" ]; then
                      cp "$file" "''${!outputName}/nix-support/$fileName"

                      while IFS=$'\t\n' read -r oldFramework newFramework; do
                        substituteInPlace "''${!outputName}/nix-support/$fileName" \
                          --replace "$oldFramework" "$newFramework"
                      done < "$dependenciesPath"
                    fi
                  done
                else
                  ln -s "$targetPath" "''${!outputName}/$targetName"
                fi
              done
            done < "$pkgOutputsPath"
          ''
        else pkg;

      # Remap a framework from one SDK version to another.
      mapPackageToSDK = pkg:
        let
          name = lib.getName pkg;
          framework = lib.removePrefix "apple-framework-" name;
        in
        /**/ if pkg == null then pkg
        else if name != framework then sdk.frameworks."${framework}"
        else replacePropagatedFrameworks pkg;

      mapRuntimeToSDK = pkg:
        # Only remap xcbuild for now, which exports the SDK used to build it.
        if pkg != null && lib.isAttrs pkg && lib.getName pkg == "xcodebuild"
          then pkg.override { stdenv = overrideSDK stdenv { inherit darwinMinVersion darwinSdkVersion; }; }
          else pkg;

      mapInputsToSDK = inputs: args:
        let
          runsAtBuild = lib.flip lib.elem [
            "depsBuildBuild"
            "depsBuildBuildPropagated"
            "nativeBuildInputs"
            "propagatedNativeBuildInputs"
            "depsBuildTarget"
            "depsBuildTargetPropagated"
          ];
          atBuildInputs = lib.filter runsAtBuild inputs;
          atRuntimeInputs = lib.subtractLists atBuildInputs inputs;
        in
        lib.genAttrs atRuntimeInputs (input: map mapPackageToSDK (args."${input}" or [ ]))
        // lib.genAttrs atBuildInputs (input: map mapRuntimeToSDK (args."${input}" or [ ]));

      mkCC = cc: cc.override {
        bintools = cc.bintools.override { libc = Libsystem; };
        libc = Libsystem;
      };
    in
    # TODO: make this work across all input types and not just propagatedBuildInputs
    stdenv.override (old: {
      buildPlatform = old.buildPlatform // { inherit darwinMinVersion darwinSdkVersion; };
      hostPlatform = old.hostPlatform // { inherit darwinMinVersion darwinSdkVersion; };
      targetPlatform = old.targetPlatform // { inherit darwinMinVersion darwinSdkVersion; };

      allowedRequisites = null;
      cc = mkCC old.cc;

      extraBuildInputs = [sdk.frameworks.CoreFoundation ];
      mkDerivationFromStdenv = extendMkDerivationArgs old (mapInputsToSDK [
        "buildInputs"
        "nativeBuildInputs"
        "propagatedNativeBuildInputs"
        "propagatedBuildInputs"
      ]);
    });
}
