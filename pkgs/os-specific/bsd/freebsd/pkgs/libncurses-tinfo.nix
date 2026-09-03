{ mkDerivation, pkgsBuildBuild }:
mkDerivation {
  path = "lib/ncurses/tinfo";
  extraPaths = [
    "lib/ncurses"
    "contrib/ncurses"
    "lib/Makefile.inc"
  ];
  CC_HOST = "${pkgsBuildBuild.stdenv.cc}/bin/cc";
  MK_TESTS = "no";
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
    make $makeFlags "CFLAGS=-D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -I$BSDSRCDIR/contrib/ncurses/ncurses -I$BSDSRCDIR/contrib/ncurses/include -I." ncurses_dll.h make_hash make_keys
  '';
}
