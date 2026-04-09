{
  lib,
  config,
  buildBuildBuildPackages,
  buildHostHostPackages,
  buildPlatform,
  hostPlatform,
  fetchurl,
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
        hostPlatform = buildPlatform;
        targetPlatform = hostPlatform;

        inherit (buildBuildBuildPackages)
          bash
          coreutils
          musl
          gnupatch
          gnused
          gnugrep
          gawk
          diffutils
          findutils
          xz
          gzip
          bzip2
          gmp
          mpfr
          mpc
          libiberty
          libbacktrace
          ;
        gnumake = buildBuildBuildPackages.gnumake-musl;
        gnutar = buildBuildBuildPackages.gnutar-latest;
      }
      // extra
    )
  )
  (
    self: with self; {
      binutils = callPackage ./binutils {
        tinycc = null;
        gcc = buildBuildBuildPackages.gcc-latest;
        binutils = buildBuildBuildPackages.binutils;
      };
      gcc-unwrapped = callPackage ./gcc/ng.nix {
        binutils-buildbuild = buildBuildBuildPackages.binutils;
        binutils-buildtarget = binutils;
        binutils-hosttarget = binutils;
        gcc = buildBuildBuildPackages.gcc-latest;
        gcc-buildbuild = buildBuildBuildPackages.gcc-latest;
        libc-headers = buildHostHostPackages.libc-headers;
        libc = buildBuildBuildPackages.musl;
      };
      gcc = callPackage ./gcc/wrapper.nix {
        bash-build = buildBuildBuildPackages.bash;
        bash = buildBuildBuildPackages.bash;
        libc = buildHostHostPackages.libc;
        libgcc = buildHostHostPackages.libgcc;
        libstdcxx = buildHostHostPackages.libstdcxx;
      };

      inherit (callPackage ./utils.nix { }) derivationWithMeta writeTextFile writeText;
      test = bash.runCommand "minimal-bootstrap-test" { } ''
        echo ${binutils.tests.get-version}
        echo ${gcc.tests.hello-world}
        mkdir ''${out}
      '';
    }
  )
