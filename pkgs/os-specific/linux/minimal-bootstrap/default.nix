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

    gnupatch = callPackage ./gnupatch { tinycc = tinycc-mes; };

    gnumake = callPackage ./gnumake { tinycc = tinycc-mes; };

    ln-boot = callPackage ./ln-boot { };

    mes = callPackage ./mes { };
    mes-libc = callPackage ./mes/libc.nix { };

    inherit (callPackage ./stage0-posix { }) kaem m2libc mescc-tools mescc-tools-extra;

    tinycc-bootstrappable = callPackage ./tinycc/bootstrappable.nix { };
    tinycc-mes = callPackage ./tinycc/mes.nix { };

    inherit (callPackage ./utils.nix { }) fetchurl derivationWithMeta writeTextFile writeText;

  })
