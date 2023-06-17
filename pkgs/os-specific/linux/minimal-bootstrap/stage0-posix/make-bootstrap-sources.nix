# Packaged resources required for the first bootstrapping stage.
# Contains source code and 256-byte hex0 binary seed.
#
# We don't have access to utilities such as fetchgit and fetchzip since this
# is this is part of the bootstrap process and would introduce a circular
# dependency. The only tool we have to fetch source trees is `import <nix/fetchurl.nix>`
# with the unpack option, taking a NAR file as input. This requires source
# tarballs to be repackaged.
#
# To build:
#
#   nix-build pkgs/os-specific/linux/minimal-bootstrap/stage0-posix/make-bootstrap-sources.nix
#   => ./result/stage0-posix-$version-$rev-source.nar.xz
#

{ pkgs ? import ../../../../.. {} }:
let
  inherit (pkgs) callPackage runCommand fetchFromGitHub nix xz;

  inherit (import ./bootstrap-sources.nix) name rev;

  src = fetchFromGitHub {
    owner = "oriansj";
    repo = "stage0-posix";
    inherit rev;
    sha256 = "sha256-ZRG0k49MxL1UTZhuMTvPoEprdSpJRNVy8QhLE6k+etg=";
    fetchSubmodules = true;
    postFetch = ''
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
runCommand name {
  nativeBuildInputs = [ nix xz ];

  passthru = { inherit src; };
} ''
  mkdir $out
  nix-store --dump ${src} | xz -c > "$out/${name}.nar.xz"
''
