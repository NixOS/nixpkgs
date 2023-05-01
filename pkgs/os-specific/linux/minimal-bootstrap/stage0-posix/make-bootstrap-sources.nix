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
#   => ./result/stage0-posix-0000000-source.nar.xz
#

{ pkgs ? import ../../../../.. {} }:
let
  inherit (pkgs) runCommand fetchFromGitHub nix xz;

  pname = "stage0-posix";
  rev = "bdd3ee779adb9f4a299059d09e68dfedecfd4226";
  shortHash = builtins.substring 0 7 rev;
  src = fetchFromGitHub {
    owner = "oriansj";
    repo = pname;
    inherit rev;
    sha256 = "hMLo32yqXiTXPyW1jpR5zprYzZW8lFQy6KMrkNQZ89I=";
    fetchSubmodules = true;
  };
in
runCommand "${pname}-${shortHash}-source" {
  nativeBuildInputs = [ nix xz ];
} ''
  mkdir $out
  nix-store --dump ${src} | xz -c > "$out/${pname}-${shortHash}-source.nar.xz"
''
