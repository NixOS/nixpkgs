{
  mkKdeDerivation,
  qtsvg,
  libplasma,
}:
mkKdeDerivation {
  pname = "merkuro";

  extraBuildInputs = [qtsvg libplasma];
}
