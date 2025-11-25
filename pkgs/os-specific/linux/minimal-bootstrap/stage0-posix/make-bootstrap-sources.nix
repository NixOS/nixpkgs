# Packaged source files for the first bootstrapping stage.
#
# We don't have access to utilities such as fetchgit and fetchzip since this
# is this is part of the bootstrap process and would introduce a circular
# dependency. The only tool we have to fetch source trees is `import <nix/fetchurl.nix>`
# with the unpack option, taking a NAR file as input. This requires source
# tarballs to be repackaged.
#
# To build:
#
#   nix-build '<nixpkgs>' -A make-minimal-bootstrap-sources
#

{
  lib,
  hostPlatform,
  fetchFromGitHub,
  fetchpatch,
}:

let
  expected = import ./bootstrap-sources.nix { inherit hostPlatform; };
in

fetchFromGitHub {
  inherit (expected) name rev;
  owner = "oriansj";
  repo = "stage0-posix";
  sha256 = expected.outputHash;
  fetchSubmodules = true;
  postFetch = ''
    # Seed binaries will be fetched separately
    echo "Removing seed binaries"
    rm -rf $out/bootstrap-seeds/*

    # Remove vendored/duplicate M2libc's
    echo "Removing duplicate M2libc"
    rm -rf \
      $out/M2-Mesoplanet/M2libc \
      $out/M2-Planet/M2libc \
      $out/mescc-tools/M2libc \
      $out/mescc-tools-extra/M2libc

    # aarch64: syscall: mkdir -> mkdirat
    # https://github.com/oriansj/M2libc/pull/17
    patch -Np1 -d $out/M2libc -i ${
      (fetchpatch {
        url = "https://github.com/oriansj/M2libc/commit/ff7c3023b3ab6cfcffc5364620b25f8d0279e96b.patch";
        hash = "sha256-QAKddv4TixIQHpFa9SVu9fAkeKbzhQaxjaWzW2yJy7A=";
      })
    }
  '';

  meta = with lib; {
    description = "Packaged sources for the first bootstrapping stage";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = licenses.gpl3Plus;
    teams = [ teams.minimal-bootstrap ];
    platforms = platforms.all;
  };
}
