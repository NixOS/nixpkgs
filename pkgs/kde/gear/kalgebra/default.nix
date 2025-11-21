{
  mkKdeDerivation,
  qtsvg,
  qtwebengine,
  ncurses,
  readline,
}:
mkKdeDerivation {
  pname = "kalgebra";

  extraBuildInputs = [
    qtsvg
    qtwebengine
    ncurses
    readline
  ];
}
