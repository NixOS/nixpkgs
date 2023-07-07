{
}:

rec {
  name = "stage0-posix-${version}-${rev}-source";
  # Pinned from https://github.com/oriansj/stage0-posix/commit/3189b5f325b7ef8b88e3edec7c1cde4fce73c76c
  version = "unstable-2023-05-02";
  rev = "3189b5f325b7ef8b88e3edec7c1cde4fce73c76c";
  outputHashAlgo = "sha256";

  # This 256 byte seed is the only pre-compiled binary in the bootstrap chain.
  hex0-seed = import <nix/fetchurl.nix> {
    name = "hex0-seed-${version}";
    url = "https://github.com/oriansj/bootstrap-seeds/raw/b1263ff14a17835f4d12539226208c426ced4fba/POSIX/x86/hex0-seed";
    hash = "sha256-QU3RPGy51W7M2xnfFY1IqruKzusrSLU+L190ztN6JW8=";
    executable = true;
  };

  /*
  Since `make-minimal-bootstrap-sources` requires nixpkgs and nix it
  will create a circular dependency if it is used in place of the
  binary bootstrap-files.  To break the circular dependency,
  `minimal-bootstrap-sources` extends `make-minimal-bootstrap-sources`
  by adding Fixed Output Derivation (FOD) attributes.  These cause
  the builder to be skipped if the expected output is found (by
  its hash) in the store or on a substituter.

  # How do I update the hash?

  Run the following command:
  ```
  nix hash file $(nix build --print-out-paths -f '<nixpkgs>' make-minimal-bootstrap-sources)
  ```

  # Why do we need this `.nar` archive?

  This archive exists only because of a quirk/limitation of Nix: in
  restricted mode the builtin fetchers can download only single
  files; they have no way to unpack multi-file archives except for
  NAR archives:

  https://github.com/NixOS/nixpkgs/pull/232576#issuecomment-1592415619

  # Why don't we have to upload this to tarballs.nixos.org like the binary bootstrap-files did?

  Unlike this archive, the binary bootstrap-files contained binaries,
  which meant that we had to:

  1. Make sure they came from a trusted builder (Hydra)
  2. Keep careful track of exactly what toolchain (i.e. nixpkgs
     commit) that builder used to create them.
  3. Keep copies of the built binaries, in case the toolchains that
     produced them failed to be perfectly deterministic.

  The curated archives at tarballs.nixos.org exist in order to
  satisfy these requirements.

  The second point created a significant burden: since the nixpkgs
  toolchain used to build a given copy of the binary bootstrap-files
  itself used a *previous* copy of the bootstrap-files, this meant
  we had to track the provenance of all bootstrap-files tarballs
  ever used, for all eternity.  There was no explanation of where
  the "original" bootstrap-files came from: turtles all the way
  down.  In spite of all this effort we still can't be sure of our
  ability to reproduce the binary bootstrap-files, since the
  compilers that built them don't always produce exactly bit-for-bit
  deterministic results.

  Since this archive contains no binaries and uses a format (NAR)
  specifically designed for bit-exact reproducibility, none of the
  requirements above apply to `minimal-bootstrap-sources`.
  */
  minimal-bootstrap-sources = derivation {
    name = "${name}.nar.xz";
    system = builtins.currentSystem;
    outputHashMode = "flat";
    inherit outputHashAlgo;
    outputHash = "sha256-ig988BiRTz92hhZZgKQW1tVPoV4aQ2D69Cq3wHvVgHg=";

    # This builder always fails, but fortunately Nix will print the
    # "builder", which is really the error message that we want the
    # user to see.
    builder = ''
      #
      #
      # Neither your store nor your substituters seems to have:
      #
      #  ${name}.nar.xz
      #
      # Please obtain or create this file, give it exactly the name
      # shown above, and then run the following command:
      #
      #   nix-store --add-fixed ${outputHashAlgo} ${name}.nar.xz
      #
      # You can create this file from an already-bootstrapped nixpkgs
      # using the following command:
      #
      #   nix-build '<nixpkgs>' -A make-minimal-bootstrap-sources
      #
      # Or, if you prefer, you can create this file using only `git`,
      # `nix`, and `xz`.  For the commands needed in order to do this,
      # see `make-bootstrap-sources.nix`.
      #
    '';
  };
}
