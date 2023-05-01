{ lib
, newScope
, stdenv
}:

lib.makeScope newScope (self: with self; {
  callPackage = self.callPackage;

  fetchurl = import ../../../build-support/fetchurl/boot.nix {
    inherit (stdenv.buildPlatform) system;
  };

  inherit (callPackage ./stage0-posix { }) kaem m2libc mescc-tools mescc-tools-extra writeTextFile writeText runCommand;

  nyacc = callPackage ./mes/nyacc.nix { };
  mes = callPackage ./mes { };

  ln-boot = callPackage ./ln-boot { };

  tinycc-with-mes-libc = callPackage ./tinycc/default.nix { };
})
