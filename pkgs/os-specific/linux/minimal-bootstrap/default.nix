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
    fetchurl = import ../../../build-support/fetchurl/boot.nix {
      inherit (buildPlatform) system;
    };

    inherit (callPackage ./stage0-posix { }) kaem m2libc mescc-tools mescc-tools-extra writeTextFile writeText runCommand;

    mes = callPackage ./mes { };
    mes-libc = callPackage ./mes/libc.nix { };

    ln-boot = callPackage ./ln-boot { };

    tinycc-bootstrappable = callPackage ./tinycc/bootstrappable.nix { };
    tinycc-mes = callPackage ./tinycc/mes.nix { };
  })
