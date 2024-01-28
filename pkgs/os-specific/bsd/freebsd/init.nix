{ lib, stdenv, mkDerivation, ... }:
mkDerivation {
  path = "sbin/init";
  extraPaths = ["sbin/mount"];
  MK_TESTS = "no";

  clangFixup = true;
}
