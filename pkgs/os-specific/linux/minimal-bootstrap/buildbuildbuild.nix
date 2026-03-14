{
  lib,
  config,
  buildPlatform,
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
        targetPlatform = buildPlatform;
      }
      // extra
    )
  )
  (
    self: with self; {
      bash_2_05 = callPackage ./bash/2.nix { tinycc = tinycc-mes; };

      bash = callPackage ./bash {
        bootBash = bash_2_05;
        tinycc = tinycc-musl;
        coreutils = coreutils-musl;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
      };

      binutils = callPackage ./binutils {
        tinycc = tinycc-musl;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
        gcc = null;
        binutils = null;
      };

      bison = callPackage ./bison {
        gcc = gcc-latest;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };

      bzip2 = callPackage ./bzip2 {
        tinycc = tinycc-musl;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
      };

      coreutils = callPackage ./coreutils { tinycc = tinycc-mes; };

      coreutils-musl = callPackage ./coreutils/musl.nix {
        bash = bash_2_05;
        tinycc = tinycc-musl;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
      };

      diffutils = callPackage ./diffutils {
        bash = bash_2_05;
        tinycc = tinycc-musl;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
      };

      findutils = callPackage ./findutils {
        tinycc = tinycc-musl;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
      };

      gawk-mes = callPackage ./gawk/mes.nix {
        bash = bash_2_05;
        tinycc = tinycc-mes;
        gnused = gnused-mes;
      };

      gawk = callPackage ./gawk {
        bash = bash_2_05;
        tinycc = tinycc-musl;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
        bootGawk = gawk-mes;
      };

      gcc46 = callPackage ./gcc/4.6.nix {
        tinycc = tinycc-musl;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
      };

      gcc46-cxx = callPackage ./gcc/4.6.cxx.nix {
        gcc = gcc46;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
      };

      gcc10-unwrapped = callPackage ./gcc/10.nix {
        gcc = gcc46-cxx;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };
      gcc10 = callPackage ./gcc/wrapper.nix {
        gcc-unwrapped = gcc10-unwrapped;
        bash-build = bash;
        libc = musl;
        libgcc = gcc10-unwrapped;
        libstdcxx = gcc10-unwrapped;
      };

      gcc-unwrapped = callPackage ./gcc/ng.nix {
        binutils-buildbuild = binutils;
        binutils-buildtarget = binutils;
        binutils-hosttarget = binutils;
        gcc = gcc10;
        gcc-buildbuild = gcc10;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
        libc-headers = musl;
        libc = musl;
      };

      gcc-latest = callPackage ./gcc/wrapper.nix {
        bash-build = bash;
        libc = musl;
      };

      mpfr = callPackage ./gcc/mpfr.nix {
        gcc = gcc10;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };
      gmp = callPackage ./gcc/gmp.nix {
        build-gcc = gcc10;
        gcc = gcc10;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };
      mpc = callPackage ./gcc/mpc.nix {
        gcc = gcc10;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };
      libbacktrace = callPackage ./gcc/libbacktrace.nix {
        gcc = gcc10;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };
      libiberty = callPackage ./gcc/libiberty.nix {
        gcc = gcc10;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };
      libgcc = callPackage ./gcc/libgcc.nix {
        binutils-buildbuild = binutils;
        gcc-buildbuild = gcc10;
        gcc = gcc-unwrapped;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
        enableShared = false;
        libc = musl;
        libc-headers = musl;
      };
      libstdcxx = callPackage ./gcc/libstdcxx.nix {
        gcc = gcc-unwrapped;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
        libc = musl;
      };

      gnugrep = callPackage ./gnugrep {
        bash = bash_2_05;
        tinycc = tinycc-mes;
      };

      gnum4 = callPackage ./gnum4 {
        gcc = gcc-latest;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };

      gnumake = callPackage ./gnumake { tinycc = tinycc-bootstrappable; };

      gnumake-musl = callPackage ./gnumake/musl.nix {
        bash = bash_2_05;
        tinycc = tinycc-musl;
        gawk = gawk-mes;
        gnumakeBoot = gnumake;
      };

      gnupatch = callPackage ./gnupatch { tinycc = tinycc-mes; };

      gnused = callPackage ./gnused {
        bash = bash_2_05;
        tinycc = tinycc-musl;
        gnused = gnused-mes;
      };

      gnused-mes = callPackage ./gnused/mes.nix {
        bash = bash_2_05;
        tinycc = tinycc-bootstrappable;
      };

      gnutar = callPackage ./gnutar/mes.nix {
        bash = bash_2_05;
        tinycc = tinycc-mes;
        gnused = gnused-mes;
      };

      # FIXME: better package naming scheme
      gnutar-latest = callPackage ./gnutar/latest.nix {
        gcc = gcc46;
        gnumake = gnumake-musl;
        gnutarBoot = gnutar-musl;
      };

      gnutar-musl = callPackage ./gnutar/musl.nix {
        bash = bash_2_05;
        tinycc = tinycc-musl;
        gnused = gnused-mes;
      };

      gzip = callPackage ./gzip {
        bash = bash_2_05;
        tinycc = tinycc-bootstrappable;
        gnused = gnused-mes;
      };

      heirloom = callPackage ./heirloom {
        bash = bash_2_05;
        tinycc = tinycc-mes;
      };

      heirloom-devtools = callPackage ./heirloom-devtools { tinycc = tinycc-mes; };

      ln-boot = callPackage ./ln-boot { };

      mes = callPackage ./mes { };

      mes-libc = callPackage ./mes/libc.nix { };

      musl-tcc-intermediate = callPackage ./musl/tcc.nix {
        bash = bash_2_05;
        tinycc = tinycc-mes;
        gnused = gnused-mes;
      };

      musl-tcc = callPackage ./musl/tcc.nix {
        bash = bash_2_05;
        tinycc = tinycc-musl-intermediate;
        gnused = gnused-mes;
      };

      musl = callPackage ./musl {
        gcc = gcc46;
        gnumake = gnumake-musl;
        libgcc = gcc46;
      };

      python = callPackage ./python {
        gcc = gcc-latest;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };

      stage0-posix = callPackage ./stage0-posix { };

      inherit (self.stage0-posix)
        kaem
        m2libc
        mescc-tools
        mescc-tools-extra
        ;

      tinycc-bootstrappable = lib.recurseIntoAttrs (callPackage ./tinycc/bootstrappable.nix { });

      tinycc-mes = lib.recurseIntoAttrs (callPackage ./tinycc/mes.nix { });

      tinycc-musl-intermediate = lib.recurseIntoAttrs (
        callPackage ./tinycc/musl.nix {
          bash = bash_2_05;
          musl = musl-tcc-intermediate;
          tinycc = tinycc-mes;
        }
      );

      tinycc-musl = lib.recurseIntoAttrs (
        callPackage ./tinycc/musl.nix {
          bash = bash_2_05;
          musl = musl-tcc;
          tinycc = tinycc-musl-intermediate;
        }
      );

      xz = callPackage ./xz {
        bash = bash_2_05;
        tinycc = tinycc-musl;
        gnumake = gnumake-musl;
        gnutar = gnutar-musl;
      };

      zlib = callPackage ./zlib {
        gcc = gcc-latest;
        gnumake = gnumake-musl;
        gnutar = gnutar-latest;
      };

      inherit (callPackage ./utils.nix { }) derivationWithMeta writeTextFile writeText;
      test = kaem.runCommand "minimal-bootstrap-test" { } ''
        echo ${bash.tests.get-version}
        echo ${bash_2_05.tests.get-version}
        echo ${binutils.tests.get-version}
        echo ${bison.tests.get-version}
        echo ${bzip2.tests.get-version}
        echo ${coreutils-musl.tests.get-version}
        echo ${diffutils.tests.get-version}
        echo ${findutils.tests.get-version}
        echo ${gawk.tests.get-version}
        echo ${gawk-mes.tests.get-version}
        echo ${gcc46.tests.get-version}
        echo ${gcc46-cxx.tests.hello-world}
        echo ${gcc10.tests.hello-world}
        echo ${gcc-latest.tests.hello-world}
        echo ${gnugrep.tests.get-version}
        echo ${gnum4.tests.get-version}
        echo ${gnumake-musl.tests.get-version}
        echo ${gnused.tests.get-version}
        echo ${gnused-mes.tests.get-version}
        echo ${gnutar.tests.get-version}
        echo ${gnutar-latest.tests.get-version}
        echo ${gnutar-musl.tests.get-version}
        echo ${gzip.tests.get-version}
        echo ${heirloom.tests.get-version}
        echo ${mes.compiler.tests.get-version}
        echo ${musl.tests.hello-world}
        echo ${python.tests.get-version}
        echo ${tinycc-mes.compiler.tests.chain}
        echo ${tinycc-musl.compiler.tests.hello-world}
        echo ${xz.tests.get-version}
        mkdir ''${out}
      '';
    }
  )
