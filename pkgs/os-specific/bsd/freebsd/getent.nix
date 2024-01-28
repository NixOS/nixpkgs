{ mkDerivation, stdenv, lib, ... }:
mkDerivation {
  path = "usr.bin/getent";
  clangFixup = true;
}
