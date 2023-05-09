{ lib
, newScope
}:

lib.makeScope newScope (self: with self; {
  inherit (import ./bootstrap-sources.nix) version hex0-seed src;

  m2libc = src + "/M2libc";

  hex0 = callPackage ./hex0.nix { };

  kaem = callPackage ./kaem { };
  kaem-minimal = callPackage ./kaem/minimal.nix { };

  inherit (callPackage ./stage0-posix-x86.nix { }) blood-elf-0 hex2 kaem-unwrapped M1 M2;

  mescc-tools = callPackage ./mescc-tools { };

  mescc-tools-extra = callPackage ./mescc-tools-extra { };
})
