{ mkDerivation, ... }:
mkDerivation {
  path = "usr.bin/sed";
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '';
  MK_TESTS = "no";
}
