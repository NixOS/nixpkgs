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
  '';

  meta = {
    description = "Packaged sources for the first bootstrapping stage";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = lib.platforms.all;
  };
}
