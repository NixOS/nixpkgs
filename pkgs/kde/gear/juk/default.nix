{
  mkKdeDerivation,
  qtsvg,
  phonon,
  taglib,
}:
mkKdeDerivation {
  pname = "juk";

  extraBuildInputs = [
    qtsvg
    phonon
    taglib
  ];

  meta.mainProgram = "juk";
}
