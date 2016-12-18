{ stdenv, fetchurl, libmnl, iproute, kernel ? null }:

# 0.0.20161216 introduced a non-backwards protocol change.
# this version is kept around to have a version compatible with nixos stable.
import ./generic.nix {
  version = "0.0.20161209";
  sha256  = "caabb9bb471a262e178162c30b8b8524cc3a05e0e9daf23a921870a4106ec886";
  inherit stdenv fetchurl libmnl iproute kernel;
}
