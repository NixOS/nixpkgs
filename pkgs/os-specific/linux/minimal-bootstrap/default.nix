{ lib
, newScope
, system
}:

lib.makeScope newScope (self: with self; {
  callPackage = self.callPackage;

  fetchurl = import ../../../build-support/fetchurl/boot.nix {
    inherit system;
  };

  inherit (callPackage ./stage0-posix { }) kaem m2libc mescc-tools mescc-tools-extra writeTextFile writeText runCommand;

  mes = callPackage ./mes { };

  tinycc-with-mes-libc = callPackage ./tinycc/default.nix { };
})
