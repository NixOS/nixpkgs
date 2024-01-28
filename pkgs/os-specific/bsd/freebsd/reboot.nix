{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "sbin/reboot";

  MK_TESTS = "no";
  clangFixup = true;
}
