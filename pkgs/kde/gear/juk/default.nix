{
  mkKdeDerivation,
  qtsvg,
  taglib,
}:
mkKdeDerivation {
  pname = "juk";

  extraBuildInputs = [
    qtsvg
    taglib
  ];
  meta.mainProgram = "juk";
}
