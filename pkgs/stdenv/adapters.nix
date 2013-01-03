/* This file contains various functions that take a stdenv and return
   a new stdenv with different behaviour, e.g. using a different C
   compiler. */

{dietlibc, fetchurl, runCommand}:


rec {


  # Override the compiler in stdenv for specific packages.
  overrideGCC = stdenv: gcc: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // { NIX_GCC = gcc; });
      inherit gcc;
    };


  # Add some arbitrary packages to buildInputs for specific packages.
  # Used to override packages in stdenv like Make.  Should not be used
  # for other dependencies.
  overrideInStdenv = stdenv: pkgs: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args //
        { buildInputs = (if args ? buildInputs then args.buildInputs else []) ++ pkgs; }
      );
    };


  # Override the setup script of stdenv.  Useful for testing new
  # versions of the setup script without causing a rebuild of
  # everything.
  #
  # Example:
  #   randomPkg = import ../bla { ...
  #     stdenv = overrideSetup stdenv ../stdenv/generic/setup-latest.sh;
  #   };
  overrideSetup = stdenv: setup: stdenv.regenerate setup;


  # Return a modified stdenv that uses dietlibc to create small
  # statically linked binaries.
  useDietLibC = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_LINK = "-static";

        # libcompat.a contains some commonly used functions.
        NIX_LDFLAGS = "-lcompat";

        # These are added *after* the command-line flags, so we'll
        # always optimise for size.
        NIX_CFLAGS_COMPILE =
          (if args ? NIX_CFLAGS_COMPILE then args.NIX_CFLAGS_COMPILE else "")
          + " -Os -s -D_BSD_SOURCE=1";

        configureFlags =
          (if args ? configureFlags then args.configureFlags else "")
          + " --disable-shared"; # brrr...

        NIX_GCC = import ../build-support/gcc-wrapper {
          inherit stdenv;
          libc = dietlibc;
          inherit (stdenv.gcc) gcc binutils nativeTools nativePrefix;
          nativeLibc = false;
        };
      });
      isDietLibC = true;
    } // {inherit fetchurl;};


  # Return a modified stdenv that uses klibc to create small
  # statically linked binaries.
  useKlibc = stdenv: klibc: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_LINK = "-static";

        # These are added *after* the command-line flags, so we'll
        # always optimise for size.
        NIX_CFLAGS_COMPILE =
          (if args ? NIX_CFLAGS_COMPILE then args.NIX_CFLAGS_COMPILE else "")
          + " -Os -s";

        configureFlags =
          (if args ? configureFlags then args.configureFlags else "")
          + " --disable-shared"; # brrr...

        NIX_GCC = runCommand "klibc-wrapper" {} ''
          mkdir -p $out/bin
          ln -s ${klibc}/bin/klcc $out/bin/gcc
          ln -s ${klibc}/bin/klcc $out/bin/cc
          mkdir -p $out/nix-support
          echo 'PATH=$PATH:${stdenv.gcc.binutils}/bin' > $out/nix-support/setup-hook
        '';
      });
      isKlibc = true;
      isStatic = true;
    } // {inherit fetchurl;};


  # Return a modified stdenv that tries to build statically linked
  # binaries.
  makeStaticBinaries = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_LINK = "-static";

        configureFlags =
          (if args ? configureFlags then toString args.configureFlags else "")
          + " --disable-shared"; # brrr...
      });
      isStatic = true;
    } // {inherit fetchurl;};


  # Return a modified stdenv that builds static libraries instead of
  # shared libraries.
  makeStaticLibraries = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        dontDisableStatic = true;
        configureFlags =
          (if args ? configureFlags then toString args.configureFlags else "")
          + " --enable-static --disable-shared";
      });
    } // {inherit fetchurl;};


  # Return a modified stdenv that adds a cross compiler to the
  # builds.
  makeStdenvCross = stdenv: cross: binutilsCross: gccCross: stdenv //
    { mkDerivation = {name ? "", buildInputs ? [], buildNativeInputs ? [],
            propagatedBuildInputs ? [], propagatedBuildNativeInputs ? [],
            selfBuildNativeInput ? false, ...}@args: let

            # *BuildInputs exists temporarily as another name for
            # *HostInputs.

            # In nixpkgs, sometimes 'null' gets in as a buildInputs element,
            # and we handle that through isAttrs.
            getBuildDrv = drv : if (builtins.isAttrs drv && drv ? buildDrv) then drv.buildDrv else drv;
            getHostDrv = drv : if (builtins.isAttrs drv && drv ? hostDrv) then drv.hostDrv else drv;
            buildNativeInputsDrvs = map (getBuildDrv) buildNativeInputs;
            buildInputsDrvs = map (getHostDrv) buildInputs;
            buildInputsDrvsAsBuildInputs = map (getBuildDrv) buildInputs;
            propagatedBuildInputsDrvs = map (getHostDrv) (propagatedBuildInputs);
            propagatedBuildNativeInputsDrvs = map (getBuildDrv)
                (propagatedBuildNativeInputs);

            # The base stdenv already knows that buildNativeInputs and
            # buildInputs should be built with the usual gcc-wrapper
            # And the same for propagatedBuildInputs.
            buildDrv = stdenv.mkDerivation args;

            # Temporary expression until the cross_renaming, to handle the
            # case of pkgconfig given as buildInput, but to be used as
            # buildNativeInput.
            hostAsBuildDrv = drv: builtins.unsafeDiscardStringContext
                drv.buildDrv.drvPath == builtins.unsafeDiscardStringContext
                drv.hostDrv.drvPath;
            buildInputsNotNull = stdenv.lib.filter
                (drv: builtins.isAttrs drv && drv ? buildDrv) buildInputs;
            nativeInputsFromBuildInputs = stdenv.lib.filter (hostAsBuildDrv) buildInputsNotNull;

            # We should overwrite the input attributes in hostDrv, to overwrite
            # the defaults for only-native builds in the base stdenv
            hostDrv = if (cross == null) then buildDrv else
                stdenv.mkDerivation (args // {
                    name = name + "-" + cross.config;
                    buildNativeInputs = buildNativeInputsDrvs
                      ++ nativeInputsFromBuildInputs
                      ++ [ gccCross binutilsCross ] ++
                      stdenv.lib.optional selfBuildNativeInput buildDrv;

                    # Cross-linking dynamic libraries, every buildInput should
                    # be propagated because ld needs the -rpath-link to find
                    # any library needed to link the program dynamically at
                    # loader time. ld(1) explains it.
                    buildInputs = [];
                    propagatedBuildInputs = propagatedBuildInputsDrvs ++
                      buildInputsDrvs;
                    propagatedBuildNativeInputs = propagatedBuildNativeInputsDrvs;

                    crossConfig = cross.config;
                } // (if args ? crossAttrs then args.crossAttrs else {}));
        in buildDrv // {
            inherit hostDrv buildDrv;
        };
    } // {
      inherit cross gccCross binutilsCross;
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


  /* Return a modified stdenv that performs the build under $out/.build
     instead of in $TMPDIR.  Thus, the sources are kept available.
     This is useful for things like debugging or generation of
     dynamic analysis reports. */
  keepBuildTree = stdenv:
    addAttrsToDerivation
      { prePhases = "moveBuildDir";

        moveBuildDir =
          ''
            mkdir -p $out/.build
            cd $out/.build
          '';
      } stdenv;


  cleanupBuildTree = stdenv:
    addAttrsToDerivation
      { postPhases = "cleanupBuildDir";

        # Get rid of everything that isn't a gcno file or a C source
        # file.  This also includes the gcda files; we're not
        # interested in coverage resulting from the package's own test
        # suite.  Also strip the `.tmp_' prefix from gcno files.  (The
        # Linux kernel creates these.)
        cleanupBuildDir =
          ''
            find $out/.build/ -type f -a ! \
              \( -name "*.c" -o -name "*.h" -o -name "*.gcno" \) \
              | xargs rm -f --

            for i in $(find $out/.build/ -name ".tmp_*.gcno"); do
                mv "$i" "$(echo $i | sed s/.tmp_//)"
            done
          '';
      } stdenv;


  /* Return a modified stdenv that builds packages with GCC's coverage
     instrumentation.  The coverage note files (*.gcno) are stored in
     $out/.build, along with the source code of the package, to enable
     programs like lcov to produce pretty-printed reports.
  */
  addCoverageInstrumentation = stdenv:
    addAttrsToDerivation
      {
        postUnpack =
          ''
            # This is an uberhack to prevent libtool from removing gcno
            # files.  This has been fixed in libtool, but there are
            # packages out there with old ltmain.sh scripts.
            # See http://www.mail-archive.com/libtool@gnu.org/msg10725.html
            for i in $(find -name ltmain.sh); do
                substituteInPlace $i --replace '*.$objext)' '*.$objext | *.gcno)'
            done

            export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -O0 --coverage"
          '';
      }

      # Object files instrumented with coverage analysis write
      # runtime coverage data to <path>/<object>.gcda, where <path>
      # is the location where gcc originally created the object
      # file.  That would be /tmp/nix-build-<something>, which will
      # be long gone by the time we run the program.  Furthermore,
      # the <object>.gcno files created at compile time are also
      # written there.  And to make nice coverage reports with lcov,
      # we need the source code.  So we have to use the
      # `keepBuildTree' adapter as well.
      (cleanupBuildTree (keepBuildTree stdenv));


  /* Replace the meta.maintainers field of a derivation.  This is useful
     when you want to fork to update some packages without disturbing other
     developers.

     e.g.:  in all-packages.nix:

     # remove all maintainers.
     defaultStdenv = replaceMaintainersField allStdenvs.stdenv pkgs [];
  */
  replaceMaintainersField = stdenv: pkgs: maintainers: stdenv //
    { mkDerivation = args:
        pkgs.lib.recursiveUpdate
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
            license =
              if pkg ? meta && pkg.meta ? license then
                pkg.meta.license
              else
                null;
          in
            builtins.trace "@:drv:${toString drvPath}:${builtins.toString license}:@"
              val;
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
     feature of ~/.nixpkgs/config.nix .
  */
  validateLicenses = licensePred: stdenv: stdenv //
    { mkDerivation = args:
        let
          pkg = stdenv.mkDerivation args;
          drv = builtins.unsafeDiscardStringContext pkg.drvPath;
          license =
            if pkg ? meta && pkg.meta ? license then
              pkg.meta.license
            else if pkg ? outputHash then
              # Fixed-output derivations such as source tarballs usually
              # don't have licensing information, but that's OK.
              null
            else
              builtins.trace
                "warning: ${drv} lacks licensing information" null;

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
        NIX_CFLAGS_COMPILE = toString (args.NIX_CFLAGS_COMPILE or "") + " -g -O0";
      });
    };

}
