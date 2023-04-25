{ lib
, system
, newScope
}:

lib.makeScope newScope (self: with self; {
  callPackage = self.callPackage;

  inherit (callPackage ./sources.nix { }) version bootstrap-seeds-src m2-mesoplanet-src m2-planet-src m2libc mescc-tools-src mescc-tools-extra-src stage0-posix-x86-src;

  hex0 = callPackage ./hex0.nix { };

  kaem-minimal = callPackage ./kaem-minimal.nix { };

  inherit (callPackage ./stage0-posix-x86.nix { }) blood-elf-0 hex2 kaem-unwrapped M1 M2;

  mkKaemDerivation0 = args@{
    name,
    script,
    ...
  }:
    derivation ({
      inherit system name;
      builder = kaem-unwrapped;
      args = [
        "--verbose"
        "--strict"
        "--file"
        script
      ];

      ARCH = "x86";
      OPERATING_SYSTEM = "linux";
      BLOOD_FLAG = " ";
      BASE_ADDRESS = "0x8048000";
      ENDIAN_FLAG = "--little-endian";
    } // (builtins.removeAttrs args [ "name" "script" ]));

  mescc-tools = callPackage ./mescc-tools { };

  mescc-tools-extra = callPackage ./mescc-tools-extra { };

  inherit (callPackage ./utils.nix { }) writeTextFile writeText runCommand fetchtarball;

  # Now that mescc-tools-extra is available we can install kaem at /bin/kaem
  # to make it findable in environments
  kaem = mkKaemDerivation0 {
    name = "kaem-${version}";
    script = builtins.toFile "kaem-wrapper.kaem" ''
      mkdir -p ''${out}/bin
      cp ''${kaem-unwrapped} ''${out}/bin/kaem
      chmod 555 ''${out}/bin/kaem
    '';
    PATH = lib.makeBinPath [ mescc-tools-extra ];
    inherit kaem-unwrapped;
  };
})
