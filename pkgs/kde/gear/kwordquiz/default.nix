{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
  qqc2-desktop-style,
}:
mkKdeDerivation {
  pname = "kwordquiz";

  extraBuildInputs = [
    qtsvg
    qtmultimedia
    qqc2-desktop-style
  ];
  meta.mainProgram = "kwordquiz";
}
