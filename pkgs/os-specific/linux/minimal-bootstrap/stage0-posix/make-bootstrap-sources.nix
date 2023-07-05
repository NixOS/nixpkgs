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
#   nix-build '<nixpkgs>' -o sources.nar.xz -A make-minimal-bootstrap-sources
#

{ lib
, fetchFromGitHub
, runCommand
, nix
, xz
}:
let
  inherit (import ./bootstrap-sources.nix { }) name rev;

  src = fetchFromGitHub {
    owner = "oriansj";
    repo = "stage0-posix";
    inherit rev;
    sha256 = "sha256-FpMp7z+B3cR3LkQ+PooH/b1/NlxH8NHVJNWifaPWt4U=";
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
  };

in
runCommand "${name}.nar.xz" {
  nativeBuildInputs = [ nix xz ];

  passthru = { inherit src; };

  meta = with lib; {
    description = "Packaged sources for the first bootstrapping stage";
    homepage = "https://github.com/oriansj/stage0-posix";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.all;
  };
} ''
  nix-store --dump ${src} | xz -c > $out
''
