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

  kaem = callPackage ./kaem { };
  kaem-minimal = callPackage ./kaem/minimal.nix { };

  inherit (callPackage ./stage0-posix-x86.nix { }) blood-elf-0 hex2 kaem-unwrapped M1 M2;

  mescc-tools = callPackage ./mescc-tools { };

  mescc-tools-extra = callPackage ./mescc-tools-extra { };

  inherit (callPackage ./utils.nix { }) derivationWithMeta writeTextFile writeText runCommand fetchtarball;
})
