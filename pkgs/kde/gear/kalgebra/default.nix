{
  mkKdeDerivation,
  qtsvg,
  qtwebengine,
  ncurses,
  readline,
}:
mkKdeDerivation {
  pname = "kalgebra";

  extraNativeBuildInputs = [ qtwebengine ];

  extraBuildInputs = [
    qtsvg
    qtwebengine
    ncurses
    readline
  ];
}
