{ mkDerivation, libjail, libcasper, libcapsicum, ... }:
mkDerivation {
  path = "usr.bin/sockstat";
  buildInputs = [
    libjail
    libcasper
    libcapsicum
  ];
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '';
}
