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
      else (mkDerivationSuper args).overrideAttrs(finalAttrs: {
        NIX_CFLAGS_LINK = toString (finalAttrs.NIX_CFLAGS_LINK or "") + " -static";
      } // lib.optionalAttrs (!(finalAttrs.dontAddStaticConfigureFlags or false)) {
        configureFlags = (finalAttrs.configureFlags or []) ++ [
            "--disable-shared" # brrr...
          ];
      }));
    } // lib.optionalAttrs (stdenv0.hostPlatform.libc == "libc") {
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
        ++ lib.optional stdenv.hasCC [
          (pkgs.buildPackages.makeSetupHook {
            name = "darwin-portable-libSystem-hook";
            substitutions = {
              libsystem = "${stdenv.cc.libc}/lib/libSystem.B.dylib";
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

    # Glibc doesn’t come with static runtimes by default.
    # ++ lib.optional (stdenv.hostPlatform.libc == "glibc") ((lib.flip overrideInStdenv) [ self.glibc.static ])
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
        wrap ld.mold ${../build-support/bintools-wrapper/ld-wrapper.sh} ${pkgs.mold}/bin/ld.mold
        wrap ld ${../build-support/bintools-wrapper/ld-wrapper.sh} ${pkgs.mold}/bin/ld.mold
      '';
    };
  in stdenv.override (old: {
    cc = stdenv.cc.override {
      inherit bintools;
    };
    allowedRequisites =
      lib.mapNullable (rs: rs ++ [ bintools pkgs.mold (lib.getLib pkgs.mimalloc) (lib.getLib pkgs.openssl) ]) (stdenv.allowedRequisites or null);
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
}
