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
    sha256 = "hMLo32yqXiTXPyW1jpR5zprYzZW8lFQy6KMrkNQZ89I=";
    fetchSubmodules = true;
  };
in
runCommand name {
  nativeBuildInputs = [ nix xz ];
} ''
  mkdir $out
  nix-store --dump ${src} | xz -c > "$out/${name}.nar.xz"
''
