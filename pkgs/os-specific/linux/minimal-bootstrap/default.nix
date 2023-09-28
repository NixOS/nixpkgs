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
      gcc = gcc2;
      glibc = glibc22;
      gawk = gawk-mes;
    };

    binutils = callPackage ./binutils {
      bash = bash_2_05;
      gcc = gcc2;
      binutils = binutils-mes;
      glibc = glibc22;
      sed = heirloom.sed;
      gawk = gawk-mes;
    };
    binutils-mes = callPackage ./binutils {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      sed = heirloom.sed;
      gawk = gawk-mes;
      mesBootstrap = true;
    };

    bzip2 = callPackage ./bzip2 {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    coreutils = callPackage ./coreutils { tinycc = tinycc-mes; };

    diffutils = callPackage ./diffutils {
      bash = bash_2_05;
      gcc = gcc2;
      glibc = glibc22;
      gawk = gawk-mes;
    };

    findutils = callPackage ./findutils {
      bash = bash_2_05;
      gcc = gcc2;
      glibc = glibc22;
      gawk = gawk-mes;
    };

    gawk-mes = callPackage ./gawk/mes.nix {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      gnused = gnused-mes;
    };

    gawk = callPackage ./gawk {
      bash = bash_2_05;
      gcc = gcc2;
      glibc = glibc22;
      bootGawk = gawk-mes;
    };

    gcc2 = callPackage ./gcc/2.nix {
      bash = bash_2_05;
      gcc = gcc2-mes;
      binutils = binutils-mes;
      glibc = glibc22;
    };
    gcc2-mes = callPackage ./gcc/2.nix {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      binutils = binutils-mes;
      mesBootstrap = true;
    };

    gcc46 = callPackage ./gcc/4.6.nix {
      gcc = gcc2;
      glibc = glibc22;
      gawk = gawk-mes;
    };

    inherit (callPackage ./glibc {
      bash = bash_2_05;
      gnused = gnused-mes;
      gawk = gawk-mes;
    }) glibc22;

    gnugrep = callPackage ./gnugrep {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    gnumake = callPackage ./gnumake { tinycc = tinycc-mes; };

    gnupatch = callPackage ./gnupatch { tinycc = tinycc-mes; };

    gnused = callPackage ./gnused {
      bash = bash_2_05;
      gcc = gcc2;
      glibc = glibc22;
      gnused = gnused-mes;
    };
    gnused-mes = callPackage ./gnused {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      mesBootstrap = true;
    };

    gnutar = callPackage ./gnutar {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      gnused = gnused-mes;
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

    mes = lib.recurseIntoAttrs (callPackage ./mes { });
    mes-libc = callPackage ./mes/libc.nix { };

    musl11 = callPackage ./musl/1.1.nix {
      bash = bash_2_05;
      tinycc = tinycc-mes;
      gnused = gnused-mes;
    };

    musl = callPackage ./musl {
      gcc = gcc46;
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
      tinycc = tinycc-mes;
      gawk = gawk-mes;
      inherit (heirloom) sed;
    };

    inherit (callPackage ./utils.nix { }) derivationWithMeta writeTextFile writeText;

    test = kaem.runCommand "minimal-bootstrap-test" {} ''
      echo ${bash.tests.get-version}
      echo ${bash_2_05.tests.get-version}
      echo ${binutils.tests.get-version}
      echo ${binutils-mes.tests.get-version}
      echo ${bzip2.tests.get-version}
      echo ${diffutils.tests.get-version}
      echo ${findutils.tests.get-version}
      echo ${gawk-mes.tests.get-version}
      echo ${gawk.tests.get-version}
      echo ${gcc2.tests.get-version}
      echo ${gcc2-mes.tests.get-version}
      echo ${gcc46.tests.get-version}
      echo ${gnugrep.tests.get-version}
      echo ${gnused.tests.get-version}
      echo ${gnused-mes.tests.get-version}
      echo ${gnutar.tests.get-version}
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
