{ mkDerivation, stdenv, lib, libkvm, libelf, ...}:
mkDerivation {
  path = "lib/libprocstat";
  extraPaths = ["lib/libc/Versions.def" "sys/contrib/openzfs" "sys/contrib/pcg-c" "sys/opencrypto" "sys/contrib/ck" "sys/crypto"];
  buildInputs = [libkvm libelf];
  MK_TESTS = "no";

  clangFixup = true;
}
