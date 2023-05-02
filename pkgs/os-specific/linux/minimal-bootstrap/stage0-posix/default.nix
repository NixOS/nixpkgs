{ lib
, newScope
}:

lib.makeScope newScope (self: with self; {
  callPackage = self.callPackage;

  # Pinned from https://github.com/oriansj/stage0-posix/commit/bdd3ee779adb9f4a299059d09e68dfedecfd4226
  version = "unstable-2023-04-24";
  rev = "bdd3ee779adb9f4a299059d09e68dfedecfd4226";

  # This 256 byte seed is the only pre-compiled binary in the bootstrap chain.
  # While it is included in the stage0-posix source bundle and is synced with
  # stage0-posix updates, we have split it out into its own derivation to highlight
  # its unique status as a trusted binary seed.
  hex0-seed = import <nix/fetchurl.nix> {
    name = "hex0-seed-${version}";
    url = "https://github.com/oriansj/bootstrap-seeds/raw/b1263ff14a17835f4d12539226208c426ced4fba/POSIX/x86/hex0-seed";
    hash = "sha256-QU3RPGy51W7M2xnfFY1IqruKzusrSLU+L190ztN6JW8=";
    executable = true;
  };

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
