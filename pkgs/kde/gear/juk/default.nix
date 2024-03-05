{
  mkKdeDerivation,
  qtsvg,
  taglib,
}:
mkKdeDerivation {
  pname = "juk";

  extraBuildInputs = [qtsvg taglib];
}
