{ lib
, newScope
, stdenv
}:

lib.makeScope newScope (self: with self; {
  callPackage = self.callPackage;

  inherit (stdenv.hostPlatform) system;

  fetchurl = import ../../../build-support/fetchurl/boot.nix {
    inherit system;
  };

  inherit (callPackage ./stage0-posix { }) kaem m2libc mescc-tools mescc-tools-extra writeTextFile writeText runCommand fetchtarball;

  mes = callPackage ./mes { };

  tinycc-with-mes-libc = callPackage ./tinycc/default.nix { };
})
