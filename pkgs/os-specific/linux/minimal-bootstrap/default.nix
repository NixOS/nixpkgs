{ lib
, config
, buildPlatform
, hostPlatform
}:

lib.makeScope
  # Prevent using top-level attrs to protect against introducing dependency on
  # non-bootstrap packages by mistake. Any top-level inputs must be explicitly
  # declared here.
  (extra: lib.callPackageWith ({ inherit lib config buildPlatform hostPlatform; } // extra))
  (self: with self; {

    bash_2_05 = callPackage ./bash/2.nix { tinycc = tinycc-mes; };

    coreutils = callPackage ./coreutils { tinycc = tinycc-mes; };

    gnupatch = callPackage ./gnupatch { tinycc = tinycc-mes; };

    gnumake = callPackage ./gnumake { tinycc = tinycc-mes; };

    ln-boot = callPackage ./ln-boot { };

    mes = callPackage ./mes { };
    mes-libc = callPackage ./mes/libc.nix { };

    stage0-posix = callPackage ./stage0-posix { };

    inherit (self.stage0-posix) kaem m2libc mescc-tools mescc-tools-extra;

    tinycc-bootstrappable = callPackage ./tinycc/bootstrappable.nix { };
    tinycc-mes = callPackage ./tinycc/mes.nix { };

    inherit (callPackage ./utils.nix { }) fetchurl derivationWithMeta writeTextFile writeText;

    test = kaem.runCommand "minimal-bootstrap-test" {} ''
      echo ${mes.compiler.tests.get-version}
      echo ${tinycc-mes.compiler.tests.chain}
      echo ${bash_2_05.tests.get-version}
      mkdir ''${out}
    '';
  })
