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

    binutils = callPackage ./binutils {
      tinycc = tinycc-musl;
      gnumake = gnumake-musl;
      gnutar = gnutar-musl;
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

    gnugrep = callPackage ./gnugrep {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    gnumake = callPackage ./gnumake { tinycc = tinycc-mes; };

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
      tinycc = tinycc-mes;
    };

    gnutar = callPackage ./gnutar/mes.nix {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      gnused = gnused-mes;
    };

    gnutar-musl = callPackage ./gnutar/musl.nix {
      bash = bash_2_05;
      tinycc = tinycc-musl;
      gnused = gnused-mes;
    };

    # FIXME: better package naming scheme
    gnutar-latest = callPackage ./gnutar/latest.nix {
      gcc = gcc46;
      gnumake = gnumake-musl;
      gnutarBoot = gnutar-musl;
    };

    gzip = callPackage ./gzip {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      gnused = gnused-mes;
    };

    heirloom = callPackage ./heirloom {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    heirloom-devtools = callPackage ./heirloom-devtools { tinycc = tinycc-mes; };

    linux-headers = callPackage ./linux-headers { bash = bash_2_05; };

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

    inherit (callPackage ./utils.nix { }) derivationWithMeta writeTextFile writeText;

    test = kaem.runCommand "minimal-bootstrap-test" {} ''
      echo ${bash.tests.get-version}
      echo ${bash_2_05.tests.get-version}
      echo ${binutils.tests.get-version}
      echo ${bzip2.tests.get-version}
      echo ${coreutils-musl.tests.get-version}
      echo ${diffutils.tests.get-version}
      echo ${findutils.tests.get-version}
      echo ${gawk-mes.tests.get-version}
      echo ${gawk.tests.get-version}
      echo ${gcc46.tests.get-version}
      echo ${gcc46-cxx.tests.hello-world}
      echo ${gcc8.tests.hello-world}
      echo ${gcc-latest.tests.hello-world}
      echo ${gnugrep.tests.get-version}
      echo ${gnused.tests.get-version}
      echo ${gnused-mes.tests.get-version}
      echo ${gnutar.tests.get-version}
      echo ${gnutar-musl.tests.get-version}
      echo ${gnutar-latest.tests.get-version}
      echo ${gzip.tests.get-version}
      echo ${heirloom.tests.get-version}
      echo ${mes.compiler.tests.get-version}
      echo ${musl.tests.hello-world}
      echo ${tinycc-mes.compiler.tests.chain}
      echo ${tinycc-musl.compiler.tests.hello-world}
      echo ${xz.tests.get-version}
      mkdir ''${out}
    '';
  })
