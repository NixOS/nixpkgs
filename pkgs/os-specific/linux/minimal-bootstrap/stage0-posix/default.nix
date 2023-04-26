{ lib
, system
, newScope
}:

lib.makeScope newScope (self: with self; {
  callPackage = self.callPackage;

  # Pinned from https://github.com/oriansj/stage0-posix/commit/bdd3ee779adb9f4a299059d09e68dfedecfd4226
  version = "unstable-2023-04-24";

  # We don't have access to utilities such as fetchgit and fetchzip since they
  # would introduce a circular dependency. The only tool we have to fetch source
  # trees is `import <nix/fetchurl.nix>` with the unpack option, taking a
  # NAR (Nix ARchive) file as input. This requires source tarballs to be repackaged.
  src = import <nix/fetchurl.nix> {
    url = "https://github.com/emilytrau/bootstrap-tools-nar-mirror/releases/download/2023-04-25/stage0-posix-${version}-source.nar.xz";
    hash = "sha256-hMLo32yqXiTXPyW1jpR5zprYzZW8lFQy6KMrkNQZ89I=";
    unpack = true;
  };

  m2libc = src + "/M2libc";

  hex0 = callPackage ./hex0.nix { };

  kaem-minimal = callPackage ./kaem-minimal.nix { };

  inherit (callPackage ./stage0-posix-x86.nix { }) blood-elf-0 hex2 kaem-unwrapped M1 M2;

  mkKaemDerivation0 = args@{
    script,
    ...
  }:
    derivationWithMeta ({
      inherit system;
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
    } // (builtins.removeAttrs args [ "script" ]));

  mescc-tools = callPackage ./mescc-tools { };

  mescc-tools-extra = callPackage ./mescc-tools-extra { };

  inherit (callPackage ./utils.nix { }) derivationWithMeta writeTextFile writeText runCommand fetchtarball;

  # Now that mescc-tools-extra is available we can install kaem at /bin/kaem
  # to make it findable in environments
  kaem = mkKaemDerivation0 {
    pname = "kaem";
    script = builtins.toFile "kaem-wrapper.kaem" ''
      mkdir -p ''${out}/bin
      cp ''${kaem-unwrapped} ''${out}/bin/kaem
      chmod 555 ''${out}/bin/kaem
    '';
    PATH = lib.makeBinPath [ mescc-tools-extra ];
    inherit version kaem-unwrapped;

    meta = with lib; {
      description = "Minimal build tool for running scripts on systems that lack any shell";
      homepage = "https://github.com/oriansj/mescc-tools";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ emilytrau ];
      platforms = [ "i686-linux" ];
    };
  };
})
