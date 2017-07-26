/* This file contains various functions that take a stdenv and return
   a new stdenv with different behaviour, e.g. using a different C
   compiler. */

pkgs:

rec {


  # Override the compiler in stdenv for specific packages.
  overrideCC = stdenv: cc: stdenv.override { allowedRequisites = null; cc = cc; };


  # Add some arbitrary packages to buildInputs for specific packages.
  # Used to override packages in stdenv like Make.  Should not be used
  # for other dependencies.
  overrideInStdenv = stdenv: pkgs:
    stdenv.override (prev: { allowedRequisites = null; extraBuildInputs = prev.extraBuildInputs or [] ++ pkgs; });


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
  makeStaticBinaries = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_LINK = "-static";
        configureFlags =
          toString args.configureFlags or ""
          + " --disable-shared"; # brrr...
      });
      isStatic = true;
    };


  # Return a modified stdenv that builds static libraries instead of
  # shared libraries.
  makeStaticLibraries = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        dontDisableStatic = true;
        configureFlags =
          toString args.configureFlags or ""
          + " --enable-static --disable-shared";
      });
    };


  # Return a modified stdenv that adds a cross compiler to the
  # builds.
  makeStdenvCross = { stdenv
                    , cc
                    , buildPlatform, hostPlatform, targetPlatform
                    } @ overrideArgs: let
    stdenv = overrideArgs.stdenv.override {
      inherit
        buildPlatform hostPlatform targetPlatform
        cc;

      allowedRequisites = null;

      # Overrides are surely not valid as packages built with this run on a
      # different platform.
      overrides = _: _: {};
    };
  in stdenv // {
    mkDerivation =
      { name ? "", buildInputs ? [], nativeBuildInputs ? []
      , propagatedBuildInputs ? [], propagatedNativeBuildInputs ? []
      , # Disabling the tests by default when cross compiling, as usually the
        # tests rely on being able to run produced binaries.
        doCheck ? false
      , configureFlags ? []
      , # Target is not included by default because most programs don't care.
        # Including it then would cause needless massive rebuilds.
        configurePlatforms   ? args.crossAttrs.configurePlatforms   or [ "build" "host" ]
      , selfNativeBuildInput ? args.crossAttrs.selfNativeBuildInput or false
      , ...
      } @ args:

      let
        # *BuildInputs exists temporarily as another name for
        # *HostInputs.

        # The base stdenv already knows that nativeBuildInputs and
        # buildInputs should be built with the usual gcc-wrapper
        # And the same for propagatedBuildInputs.
        nativeDrv = stdenv.mkDerivation args;

        # Temporary expression until the cross_renaming, to handle the
        # case of pkgconfig given as buildInput, but to be used as
        # nativeBuildInput.
        hostAsNativeDrv = drv:
            builtins.unsafeDiscardStringContext drv.nativeDrv.drvPath
            == builtins.unsafeDiscardStringContext drv.crossDrv.drvPath;
        buildInputsNotNull = stdenv.lib.filter
            (drv: builtins.isAttrs drv && drv ? nativeDrv) buildInputs;
        nativeInputsFromBuildInputs = stdenv.lib.filter hostAsNativeDrv buildInputsNotNull;
      in
        stdenv.mkDerivation (args // {
          name = name + "-" + hostPlatform.config;
          nativeBuildInputs = nativeBuildInputs
            ++ nativeInputsFromBuildInputs
            ++ stdenv.lib.optional selfNativeBuildInput nativeDrv
              # without proper `file` command, libtool sometimes fails
              # to recognize 64-bit DLLs
            ++ stdenv.lib.optional (hostPlatform.config == "x86_64-w64-mingw32") pkgs.file
            ++ stdenv.lib.optional (hostPlatform.config == "aarch64-linux-gnu") pkgs.updateAutotoolsGnuConfigScriptsHook
            ;

          inherit doCheck;

          # This parameter is sometimes a string and sometimes a list, yuck
          configureFlags = let inherit (stdenv.lib) optional elem; in
            (if stdenv.lib.isString configureFlags then [configureFlags] else configureFlags)
            ++ optional (elem "build"  configurePlatforms) "--build=${buildPlatform.config}"
            ++ optional (elem "host"   configurePlatforms) "--host=${hostPlatform.config}"
            ++ optional (elem "target" configurePlatforms) "--target=${targetPlatform.config}";

          # Cross-linking dynamic libraries, every buildInput should
          # be propagated because ld needs the -rpath-link to find
          # any library needed to link the program dynamically at
          # loader time. ld(1) explains it.
          buildInputs = [];
          propagatedBuildInputs = propagatedBuildInputs ++ buildInputs;
          propagatedNativeBuildInputs = propagatedNativeBuildInputs;

          crossConfig = hostPlatform.config;
        } // args.crossAttrs or {});
  };


  /* Modify a stdenv so that the specified attributes are added to
     every derivation returned by its mkDerivation function.

     Example:
       stdenvNoOptimise =
         addAttrsToDerivation
           { NIX_CFLAGS_COMPILE = "-O0"; }
           stdenv;
  */
  addAttrsToDerivation = extraAttrs: stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // extraAttrs); };


  /* Return a modified stdenv that builds packages with GCC's coverage
     instrumentation.  The coverage note files (*.gcno) are stored in
     $out/.build, along with the source code of the package, to enable
     programs like lcov to produce pretty-printed reports.
  */
  addCoverageInstrumentation = stdenv:
    overrideInStdenv stdenv [ pkgs.enableGCOVInstrumentation pkgs.keepBuildTree ];


  /* Replace the meta.maintainers field of a derivation.  This is useful
     when you want to fork to update some packages without disturbing other
     developers.

     e.g.:  in all-packages.nix:

     # remove all maintainers.
     defaultStdenv = replaceMaintainersField allStdenvs.stdenv pkgs [];
  */
  replaceMaintainersField = stdenv: pkgs: maintainers: stdenv //
    { mkDerivation = args:
        stdenv.lib.recursiveUpdate
          (stdenv.mkDerivation args)
          { meta.maintainers = maintainers; };
    };


  /* Use the trace output to report all processed derivations with their
     license name.
  */
  traceDrvLicenses = stdenv: stdenv //
    { mkDerivation = args:
        let
          pkg = stdenv.mkDerivation args;
          printDrvPath = val: let
            drvPath = builtins.unsafeDiscardStringContext pkg.drvPath;
            license = pkg.meta.license or null;
          in
            builtins.trace "@:drv:${toString drvPath}:${builtins.toString license}:@" val;
        in pkg // {
          outPath = printDrvPath pkg.outPath;
          drvPath = printDrvPath pkg.drvPath;
        };
    };


  /* Abort if the license predicate is not verified for a derivation
     declared with mkDerivation.

     One possible predicate to avoid all non-free packages can be achieved
     with the following function:

     isFree = license: with builtins;
       if isNull license then true
       else if isList license then lib.all isFree license
       else license != "non-free" && license != "unfree";

     This adapter can be defined on the defaultStdenv definition.  You can
     use it by patching the all-packages.nix file or by using the override
     feature of ~/.config/nixpkgs/config.nix .
  */
  validateLicenses = licensePred: stdenv: stdenv //
    { mkDerivation = args:
        let
          pkg = stdenv.mkDerivation args;
          drv = builtins.unsafeDiscardStringContext pkg.drvPath;
          license =
            pkg.meta.license or
              # Fixed-output derivations such as source tarballs usually
              # don't have licensing information, but that's OK.
              (pkg.outputHash or
                (builtins.trace
                  "warning: ${drv} lacks licensing information" null));

          validate = arg:
            if licensePred license then arg
            else abort ''
              while building ${drv}:
              license `${builtins.toString license}' does not pass the predicate.
            '';

        in pkg // {
          outPath = validate pkg.outPath;
          drvPath = validate pkg.drvPath;
        };
    };


  /* Modify a stdenv so that it produces debug builds; that is,
     binaries have debug info, and compiler optimisations are
     disabled. */
  keepDebugInfo = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        dontStrip = true;
        NIX_CFLAGS_COMPILE = toString (args.NIX_CFLAGS_COMPILE or "") + " -ggdb -Og";
      });
    };


  /* Modify a stdenv so that it uses the Gold linker. */
  useGoldLinker = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_LINK = toString (args.NIX_CFLAGS_LINK or "") + " -fuse-ld=gold";
      });
    };
}
