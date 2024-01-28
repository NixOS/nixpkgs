{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "sbin/sysctl";

  clangFixup = true;

  MK_TESTS = "no";
}
