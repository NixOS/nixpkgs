{ lib, hostVersion, mkDerivation, libncurses-tinfo, ...}:
mkDerivation {
  path = "lib/ncurses/ncurses";
  extraPaths = ["lib/ncurses" "contrib/ncurses" "lib/Makefile.inc"];
  MK_TESTS = "no";
  preBuild = lib.optionalString (hostVersion != "13.2") ''
    make -C ../tinfo $makeFlags curses.h ncurses_dll.h ncurses_def.h
  '';
  buildInputs = lib.optionals (hostVersion != "13.2") [libncurses-tinfo];

  # some packages depend on libncursesw.so.8
  postInstall = ''
    ln -s $out/lib/libncursesw.so.9 $out/lib/libncursesw.so.8
  '';
}
