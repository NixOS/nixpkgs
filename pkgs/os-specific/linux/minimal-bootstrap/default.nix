{ lib
, config
, buildPlatform
, hostPlatform
, fetchurl
, checkMeta
}:

lib.makeScope
  # Prevent using top-level attrs to protect against introducing dependency on
  # non-bootstrap packages by mistake. Any top-level inputs must be explicitly
  # declared here.
  (extra: lib.callPackageWith ({ inherit lib config buildPlatform hostPlatform fetchurl checkMeta; } // extra))
  (self: with self; {

    bash_2_05 = callPackage ./bash/2.nix { tinycc = tinycc-mes; };

    bash = callPackage ./bash {
      bootBash = bash_2_05;
      tinycc = tinycc-musl;
      coreutils = coreutils-musl;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
    };

    bash-static = callPackage ./bash/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    binutils = callPackage ./binutils {
      tinycc = tinycc-musl;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
    };

    binutils-static = callPackage ./binutils/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    bison = callPackage ./bison {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    busybox-static = callPackage ./busybox/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    bzip2 = callPackage ./bzip2 {
      tinycc = tinycc-musl;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
    };

    bzip2-static = callPackage ./bzip2/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    coreutils = callPackage ./coreutils { tinycc = tinycc-mes; };
    coreutils-musl = callPackage ./coreutils/musl.nix {
      bash = bash_2_05;
      tinycc = tinycc-musl;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
    };
    coreutils-static = callPackage ./coreutils/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    diffutils = callPackage ./diffutils {
      bash = bash_2_05;
      tinycc = tinycc-musl;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
    };

    diffutils-static = callPackage ./diffutils/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    findutils = callPackage ./findutils {
      tinycc = tinycc-musl;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
    };

    findutils-static = callPackage ./findutils/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    gawk = callPackage ./gawk {
      bash = bash_2_05;
      tinycc = tinycc-musl;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
      bootGawk = gawk-mes;
    };

    gawk-mes = callPackage ./gawk/mes.nix {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      gnused = gnused-mes;
    };

    gawk-static = callPackage ./gawk/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    gcc46 = callPackage ./gcc/4.6.nix {
      tinycc = tinycc-musl;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
      # FIXME: not sure why new gawk doesn't work
      gawk = gawk-mes;
    };
    gcc46-cxx = callPackage ./gcc/4.6.cxx.nix {
      gcc = gcc46;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
      # FIXME: not sure why new gawk doesn't work
      gawk = gawk-mes;
    };

    gcc8 = callPackage ./gcc/8.nix {
      gcc = gcc46-cxx;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
      # FIXME: not sure why new gawk doesn't work
      gawk = gawk-mes;
    };

    gcc-latest = callPackage ./gcc/latest.nix {
      gcc = gcc8;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
      # FIXME: not sure why new gawk doesn't work
      gawk = gawk-mes;
    };

    glibc = callPackage ./glibc {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
      gnugrep = gnugrep-static;
      gawk = gawk-static;
    };

    gnugrep = callPackage ./gnugrep {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    gnugrep-static = callPackage ./gnugrep/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    gnum4 = callPackage ./gnum4 {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    gnumake = callPackage ./gnumake { tinycc = tinycc-mes; };

    gnumake-musl = callPackage ./gnumake/musl.nix {
      bash = bash_2_05;
      tinycc = tinycc-musl;
      gawk = gawk-mes;
      gnumakeBoot = gnumake;
    };

    gnumake-static = callPackage ./gnumake/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    gnupatch = callPackage ./gnupatch { tinycc = tinycc-mes; };

    gnupatch-static = callPackage ./gnupatch/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    gnused = callPackage ./gnused {
      bash = bash_2_05;
      tinycc = tinycc-musl;
      gnused = gnused-mes;
    };
    gnused-mes = callPackage ./gnused/mes.nix {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };
    gnused-static = callPackage ./gnused/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
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

    gnutar-static = callPackage ./gnutar/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutarBoot = gnutar-latest;
    };

    gzip = callPackage ./gzip {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      gnused = gnused-mes;
    };

    gzip-static = callPackage ./gzip/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    heirloom = callPackage ./heirloom {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    heirloom-devtools = callPackage ./heirloom-devtools { tinycc = tinycc-mes; };

    linux-headers = callPackage ./linux-headers {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    ln-boot = callPackage ./ln-boot { };

    mes = callPackage ./mes { };
    mes-libc = callPackage ./mes/libc.nix { };

    musl11 = callPackage ./musl/1.1.nix {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      gnused = gnused-mes;
    };

    musl = callPackage ./musl {
      gcc = gcc46;
      gnumake = gnumake-musl;
    };

    patchelf-static = callPackage ./patchelf/static.nix {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    python = callPackage ./python {
      gcc = gcc-latest;
      gnumake = gnumake-musl;
      gnutar = gnutar-latest;
    };

    stage0-posix = callPackage ./stage0-posix { };

    inherit (self.stage0-posix) kaem m2libc mescc-tools mescc-tools-extra;

    tinycc-bootstrappable = lib.recurseIntoAttrs (callPackage ./tinycc/bootstrappable.nix { });
    tinycc-mes = lib.recurseIntoAttrs (callPackage ./tinycc/mes.nix { });
    tinycc-musl = lib.recurseIntoAttrs (callPackage ./tinycc/musl.nix {
      bash = bash_2_05;
      musl = musl11;
    });

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

    test = kaem.runCommand "minimal-bootstrap-test" {} ''
      echo ${bash.tests.get-version}
      echo ${bash-static.tests.get-version}
      echo ${bash_2_05.tests.get-version}
      echo ${binutils.tests.get-version}
      echo ${binutils-static.tests.get-version}
      echo ${bison.tests.get-version}
      echo ${busybox-static.tests.get-version}
      echo ${bzip2.tests.get-version}
      echo ${bzip2-static.tests.get-version}
      echo ${coreutils-musl.tests.get-version}
      echo ${coreutils-static.tests.get-version}
      echo ${diffutils.tests.get-version}
      echo ${diffutils-static.tests.get-version}
      echo ${findutils.tests.get-version}
      echo ${findutils-static.tests.get-version}
      echo ${gawk.tests.get-version}
      echo ${gawk-mes.tests.get-version}
      echo ${gawk-static.tests.get-version}
      echo ${gcc46.tests.get-version}
      echo ${gcc46-cxx.tests.hello-world}
      echo ${gcc8.tests.hello-world}
      echo ${gcc-latest.tests.hello-world}
      echo ${glibc.tests.hello-world}
      echo ${gnugrep.tests.get-version}
      echo ${gnugrep-static.tests.get-version}
      echo ${gnum4.tests.get-version}
      echo ${gnumake-musl.tests.get-version}
      echo ${gnumake-static.tests.get-version}
      echo ${gnupatch-static.tests.get-version}
      echo ${gnused.tests.get-version}
      echo ${gnused-mes.tests.get-version}
      echo ${gnused-static.tests.get-version}
      echo ${gnutar.tests.get-version}
      echo ${gnutar-latest.tests.get-version}
      echo ${gnutar-musl.tests.get-version}
      echo ${gnutar-static.tests.get-version}
      echo ${gzip.tests.get-version}
      echo ${gzip-static.tests.get-version}
      echo ${heirloom.tests.get-version}
      echo ${mes.compiler.tests.get-version}
      echo ${musl.tests.hello-world}
      echo ${patchelf-static.tests.get-version}
      echo ${python.tests.get-version}
      echo ${tinycc-mes.compiler.tests.chain}
      echo ${tinycc-musl.compiler.tests.hello-world}
      echo ${xz.tests.get-version}
      mkdir ''${out}
    '';
  })
