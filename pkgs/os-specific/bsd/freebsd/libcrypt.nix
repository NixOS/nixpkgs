{ mkDerivation, stdenv, lib, ... }:
mkDerivation {
  path = "lib/libcrypt";

  extraPaths = [ "lib/libmd" "sys/crypto/sha2" ];

  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '';
  MK_TESTS = "no";
}
