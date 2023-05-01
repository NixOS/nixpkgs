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

  mes = callPackage ./mes { };
  inherit (mes) mes-libc;

  ln-boot = callPackage ./ln-boot { };

  tinycc-mes = callPackage ./tinycc/default.nix { };
})
