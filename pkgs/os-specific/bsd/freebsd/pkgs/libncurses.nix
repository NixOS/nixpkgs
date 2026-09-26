{
  lib,
  versionData,
  mkDerivation,
  libncurses-tinfo,
  ...
}:
mkDerivation {
  path = "lib/ncurses/ncurses";
  extraPaths = [
    "lib/ncurses"
    "contrib/ncurses"
    "lib/Makefile.inc"
  ];
  MK_TESTS = "no";
  preBuild = lib.optionalString (versionData.major >= 14) ''
    make -C ../tinfo $makeFlags curses.h ncurses_dll.h ncurses_def.h
  '';
  buildInputs = lib.optionals (versionData.major >= 14) [ libncurses-tinfo ];

  # some packages depend on libncursesw.so.8
  postInstall = ''
    ln -s $out/lib/libncursesw.so.9 $out/lib/libncursesw.so.8
  '';
}
