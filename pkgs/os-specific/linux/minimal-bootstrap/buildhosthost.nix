{
  lib,
  config,
  buildPlatform,
  hostPlatform,
  fetchurl,
  buildBuildBuildPackages,
  buildBuildHostPackages,
  checkMeta,
}:
lib.makeScope
  # Prevent using top-level attrs to protect against introducing dependency on
  # non-bootstrap packages by mistake. Any top-level inputs must be explicitly
  # declared here.
  (
    extra:
    lib.callPackageWith (
      {
        inherit
          lib
          config
          fetchurl
          checkMeta
          ;
        buildPlatform = buildPlatform;
        hostPlatform = hostPlatform;
        targetPlatform = hostPlatform;
        inherit (buildBuildBuildPackages)
          bash
          coreutils
          gnupatch
          gnused
          gnugrep
          gawk
          diffutils
          findutils
          xz
          gzip
          bzip2
          ;
        gnumake = buildBuildBuildPackages.gnumake-musl;
        gnutar = buildBuildBuildPackages.gnutar-latest;
        binutils = buildBuildHostPackages.binutils;
      }
      // extra
    )
  )
  (
    self: with self; {
      bash-static = callPackage ./bash/static.nix {
        gcc-buildbuild = buildBuildBuildPackages.gcc-latest;
        gcc = buildBuildHostPackages.gcc;
      };

      binutils-static = callPackage ./binutils/static.nix {
        gcc-buildbuild = buildBuildBuildPackages.gcc-latest;
        gcc = buildBuildHostPackages.gcc;
      };

      bzip2-static = callPackage ./bzip2/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      coreutils-static = callPackage ./coreutils/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      diffutils-static = callPackage ./diffutils/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      findutils-static = callPackage ./findutils/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      gawk-static = callPackage ./gawk/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      libc =
        if hostPlatform.isMusl then
          callPackage ./musl/static.nix {
            gcc = buildBuildHostPackages.gcc-unwrapped;
            libgcc = libgcc-static;
          }
        else
          callPackage ./glibc/default.nix {
            binutils = buildBuildHostPackages.binutils;
            bison = buildBuildBuildPackages.bison;
            gcc = buildBuildHostPackages.gcc-unwrapped;
            python = buildBuildBuildPackages.python;
            libgcc = libgcc-static;
          };

      mpfr = callPackage ./gcc/mpfr.nix {
        gcc = buildBuildHostPackages.gcc;
      };
      gmp = callPackage ./gcc/gmp.nix {
        build-gcc = buildBuildBuildPackages.gcc-latest;
        gcc = buildBuildHostPackages.gcc;
      };
      mpc = callPackage ./gcc/mpc.nix {
        gcc = buildBuildHostPackages.gcc;
      };
      libbacktrace = callPackage ./gcc/libbacktrace.nix {
        gcc = buildBuildHostPackages.gcc;
      };
      libiberty = callPackage ./gcc/libiberty.nix {
        gcc = buildBuildHostPackages.gcc;
      };
      libgcc-static = callPackage ./gcc/libgcc.nix {
        enableShared = false;
        libc = null;
        gmp = buildBuildBuildPackages.gmp;
        mpc = buildBuildBuildPackages.mpc;
        mpfr = buildBuildBuildPackages.mpfr;
        libiberty = buildBuildBuildPackages.libiberty;
        binutils-buildbuild = buildBuildBuildPackages.binutils;
        gcc-buildbuild = buildBuildBuildPackages.gcc-latest;
        gcc = buildBuildHostPackages.gcc-unwrapped;
      };
      libgcc = callPackage ./gcc/libgcc.nix {
        enableShared = true;
        gmp = buildBuildBuildPackages.gmp;
        mpc = buildBuildBuildPackages.mpc;
        mpfr = buildBuildBuildPackages.mpfr;
        libiberty = buildBuildBuildPackages.libiberty;
        binutils-buildbuild = buildBuildBuildPackages.binutils;
        gcc-buildbuild = buildBuildBuildPackages.gcc-latest;
        gcc = buildBuildHostPackages.gcc-unwrapped;
      };
      libstdcxx = callPackage ./gcc/libstdcxx.nix {
        gcc = buildBuildHostPackages.gcc-unwrapped;
      };

      gcc-unwrapped = callPackage ./gcc/ng.nix {
        binutils-buildbuild = buildBuildBuildPackages.binutils;
        binutils-buildtarget = buildBuildHostPackages.binutils;
        binutils-hosttarget = binutils-static;
        gcc = buildBuildHostPackages.gcc;
        gcc-buildbuild = buildBuildBuildPackages.gcc-latest;
      };

      gcc = callPackage ./gcc/wrapper.nix {
        binutils = binutils-static;
        bash-build = buildBuildBuildPackages.bash;
        bash = bash-static;
        libc = libc;
      };

      gnugrep-static = callPackage ./gnugrep/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      gnumake-static = callPackage ./gnumake/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      gnupatch-static = callPackage ./gnupatch/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      gnused-static = callPackage ./gnused/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      gnutar-static = callPackage ./gnutar/static.nix {
        gcc = buildBuildHostPackages.gcc;
        gnutarBoot = buildBuildBuildPackages.gnutar-musl;
      };

      gzip-static = callPackage ./gzip/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      libc-headers =
        if hostPlatform.isMusl then
          callPackage ./musl/headers.nix {
            gcc = buildBuildBuildPackages.gcc-latest;
          }
        else
          callPackage ./glibc/headers.nix {
            binutils-build = buildBuildBuildPackages.binutils;
            bison = buildBuildBuildPackages.bison;
            gcc = buildBuildBuildPackages.gcc-latest;
            python = buildBuildBuildPackages.python;
          };

      linux-headers = callPackage ./linux-headers {
        gcc = buildBuildBuildPackages.gcc-latest;
      };

      patchelf-static = callPackage ./patchelf/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      xz-static = callPackage ./xz/static.nix {
        gcc = buildBuildHostPackages.gcc;
      };

      inherit (callPackage ./utils.nix { }) derivationWithMeta writeTextFile writeText;
      test = bash.runCommand "minimal-bootstrap-test" { } ''
        echo ${bash-static.tests.get-version}
        echo ${binutils-static.tests.get-version}
        echo ${bzip2-static.tests.get-version}
        echo ${coreutils-static.tests.get-version}
        echo ${diffutils-static.tests.get-version}
        echo ${findutils-static.tests.get-version}
        echo ${gawk-static.tests.get-version}
        echo ${gnugrep-static.tests.get-version}
        echo ${gnumake-static.tests.get-version}
        echo ${gnupatch-static.tests.get-version}
        echo ${gnused-static.tests.get-version}
        echo ${gnutar-static.tests.get-version}
        echo ${gzip-static.tests.get-version}
        echo ${patchelf-static.tests.get-version}
        mkdir ''${out}
      '';
    }
  )
