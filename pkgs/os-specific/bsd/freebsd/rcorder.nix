{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "sbin/rcorder";

  clangFixup = true;
}
