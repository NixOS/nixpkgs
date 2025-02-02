{
  mkKdeDerivation,
  qtsvg,
  _7zz,
  shared-mime-info,
  black-hole-solver,
  freecell-solver,
  libkdegames,
}:
mkKdeDerivation {
  pname = "kpat";

  extraNativeBuildInputs = [_7zz shared-mime-info];
  extraBuildInputs = [
    qtsvg
    black-hole-solver
    freecell-solver
  ];

  qtWrapperArgs = ["--prefix XDG_DATA_DIRS : ${libkdegames}/share"];
  meta.mainProgram = "kpat";
}
