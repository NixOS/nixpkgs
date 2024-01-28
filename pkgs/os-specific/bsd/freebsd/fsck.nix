{ lib, stdenv, mkDerivation, ... }:
mkDerivation {
  path = "sbin/fsck";
  extraPaths = ["sbin/mount"];

  clangFixup = true;
}
