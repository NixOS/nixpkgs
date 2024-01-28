{ mkDerivation, stdenv, lib, ... }:
mkDerivation {
  path = "lib/libcrypt";

  extraPaths = [ "lib/libmd" "sys/crypto/sha2" ];

  clangFixup = true;
  MK_TESTS = "no";
}
