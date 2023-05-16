{ lib
, newScope
}:

lib.makeScope newScope (self: with self; {
<<<<<<< HEAD
  inherit (callPackage ./platforms.nix { }) platforms stage0Arch m2libcArch m2libcOS baseAddress;

  inherit (self.callPackage ./bootstrap-sources.nix {}) version minimal-bootstrap-sources;

  src = minimal-bootstrap-sources;
=======
  inherit (import ./bootstrap-sources.nix) version hex0-seed src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  m2libc = src + "/M2libc";

  hex0 = callPackage ./hex0.nix { };
<<<<<<< HEAD
  inherit (self.hex0) hex0-seed;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  kaem = callPackage ./kaem { };
  kaem-minimal = callPackage ./kaem/minimal.nix { };

<<<<<<< HEAD
  mescc-tools-boot = callPackage ./mescc-tools-boot.nix { };

  inherit (self.mescc-tools-boot) blood-elf-0 hex2 kaem-unwrapped M1 M2;
=======
  inherit (callPackage ./stage0-posix-x86.nix { }) blood-elf-0 hex2 kaem-unwrapped M1 M2;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  mescc-tools = callPackage ./mescc-tools { };

  mescc-tools-extra = callPackage ./mescc-tools-extra { };
})
