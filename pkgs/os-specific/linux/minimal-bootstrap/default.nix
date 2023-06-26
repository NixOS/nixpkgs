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

    bzip2 = callPackage ./bzip2 {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    coreutils = callPackage ./coreutils { tinycc = tinycc-mes; };

    gawk = callPackage ./gawk {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    gnugrep = callPackage ./gnugrep {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    gnumake = callPackage ./gnumake { tinycc = tinycc-mes; };

    gnupatch = callPackage ./gnupatch { tinycc = tinycc-mes; };

    gnused = callPackage ./gnused {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    gnutar = callPackage ./gnutar {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    gzip = callPackage ./gzip {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    heirloom = callPackage ./heirloom {
      bash = bash_2_05;
      tinycc = tinycc-mes;
    };

    heirloom-devtools = callPackage ./heirloom-devtools { tinycc = tinycc-mes; };

    ln-boot = callPackage ./ln-boot { };

    mes = lib.recurseIntoAttrs (callPackage ./mes { });
    mes-libc = callPackage ./mes/libc.nix { };

    stage0-posix = callPackage ./stage0-posix { };

    inherit (self.stage0-posix) kaem m2libc mescc-tools mescc-tools-extra;

    tinycc-bootstrappable = lib.recurseIntoAttrs (callPackage ./tinycc/bootstrappable.nix { });
    tinycc-mes = lib.recurseIntoAttrs (callPackage ./tinycc/mes.nix { });

    inherit (callPackage ./utils.nix { }) derivationWithMeta writeTextFile writeText;

    test = kaem.runCommand "minimal-bootstrap-test" {} ''
      echo ${bash_2_05.tests.get-version}
      echo ${bzip2.tests.get-version}
      echo ${gawk.tests.get-version}
      echo ${gnugrep.tests.get-version}
      echo ${gnused.tests.get-version}
      echo ${gnutar.tests.get-version}
      echo ${gzip.tests.get-version}
      echo ${heirloom.tests.get-version}
      echo ${mes.compiler.tests.get-version}
      echo ${tinycc-mes.compiler.tests.chain}
      mkdir ''${out}
    '';
  })
