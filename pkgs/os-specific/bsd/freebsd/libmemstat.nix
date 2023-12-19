{ mkDerivation, stdenv, lib, libkvm, ...}:
mkDerivation {
  path = "lib/libmemstat";
  extraPaths = [];
  buildInputs = [libkvm];
  MK_TESTS = "no";

  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '';
}
