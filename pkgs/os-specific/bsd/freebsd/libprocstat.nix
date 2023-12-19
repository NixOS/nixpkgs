{ mkDerivation, stdenv, lib, libkvm, libelf, ...}:
mkDerivation {
  path = "lib/libprocstat";
  extraPaths = ["lib/libc/Versions.def" "sys/contrib/openzfs" "sys/contrib/pcg-c" "sys/opencrypto" "sys/contrib/ck" "sys/crypto"];
  buildInputs = [libkvm libelf];
  MK_TESTS = "no";

  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '';
}
