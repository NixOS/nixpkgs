{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "usr.bin/id";

  clangFixup = true;
}
