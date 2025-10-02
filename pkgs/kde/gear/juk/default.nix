{
  mkKdeDerivation,
  qtmultimedia,
  qtsvg,
  taglib,
}:
mkKdeDerivation {
  pname = "juk";

  extraBuildInputs = [
    qtmultimedia
    qtsvg
    taglib
  ];

  meta.mainProgram = "juk";
}
