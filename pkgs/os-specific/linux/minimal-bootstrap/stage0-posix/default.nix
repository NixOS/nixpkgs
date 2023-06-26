{ lib
, newScope
}:

lib.makeScope newScope (self: with self; {
  inherit (self.callPackage ./bootstrap-sources.nix {})
    version hex0-seed minimal-bootstrap-sources;

  src = minimal-bootstrap-sources;

  m2libc = src + "/M2libc";

  hex0 = callPackage ./hex0.nix { };

  kaem = callPackage ./kaem { };
  kaem-minimal = callPackage ./kaem/minimal.nix { };

  stage0-posix-x86 = callPackage ./stage0-posix-x86.nix { };

  inherit (self.stage0-posix-x86) blood-elf-0 hex2 kaem-unwrapped M1 M2;

  mescc-tools = callPackage ./mescc-tools { };

  mescc-tools-extra = callPackage ./mescc-tools-extra { };
})
