{
  mkDerivation,
  libncurses-tinfo,
  libncurses,
}:
mkDerivation {
  pname = "ncurses-form";
  path = "lib/ncurses/form";
  extraPaths = [
    "lib/ncurses"
    "contrib/ncurses"
    "lib/Makefile.inc"
  ];
  buildInputs = [
    libncurses-tinfo
    libncurses
  ];
}
