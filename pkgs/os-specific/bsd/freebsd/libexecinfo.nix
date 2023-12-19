{ mkDerivation, lib, stdenv, libelf, ...}:
mkDerivation {
  path = "lib/libexecinfo";
  extraPaths = ["contrib/libexecinfo"];
  buildInputs = [libelf];
  MK_TESTS = "no";
  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_WCHAR_T -D_SIZE_T"
  '';
}
