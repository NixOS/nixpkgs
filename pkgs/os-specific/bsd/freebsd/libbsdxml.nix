{ mkDerivation, lib, stdenv, ...}:
mkDerivation {
  path = "lib/libexpat";
  extraPaths = ["contrib/expat"];
  buildInputs = [];
  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T -Dwchar_t=int -D_WCHAR_T_DECLARED"
  '';
}
