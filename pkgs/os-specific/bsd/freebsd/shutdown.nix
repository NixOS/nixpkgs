{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "sbin/shutdown";

  MK_TESTS = "no";
  clangFixup = true;
  preBuild = ''
    sed -i 's/4554/0554/' Makefile
  '';
}
