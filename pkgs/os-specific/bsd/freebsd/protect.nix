{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "usr.bin/protect";

  clangFixup = true;
}
