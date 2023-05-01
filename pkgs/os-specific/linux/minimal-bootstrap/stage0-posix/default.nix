{ lib
, newScope
}:

lib.makeScope newScope (self: with self; {
  callPackage = self.callPackage;

  # Pinned from https://github.com/oriansj/stage0-posix/commit/bdd3ee779adb9f4a299059d09e68dfedecfd4226
  version = "unstable-2023-04-24";
  rev = "bdd3ee779adb9f4a299059d09e68dfedecfd4226";

  # Packaged resources required for the first bootstrapping stage.
  # Contains source code and 256-byte hex0 binary seed.
  #
  # We don't have access to utilities such as fetchgit and fetchzip since this
  # is this is part of the bootstrap process and would introduce a circular
  # dependency. The only tool we have to fetch source trees is `import <nix/fetchurl.nix>`
  # with the unpack option, taking a NAR file as input. This requires source
  # tarballs to be repackaged.
  #
  # To build see `make-bootstrap-sources.nix`
  src = import <nix/fetchurl.nix> {
    url = "https://github.com/emilytrau/bootstrap-tools-nar-mirror/releases/download/2023-04-25/stage0-posix-${builtins.substring 0 7 rev}-source.nar.xz";
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

  inherit (callPackage ./utils.nix { }) derivationWithMeta writeTextFile writeText runCommand;
})
