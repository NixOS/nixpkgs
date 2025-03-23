{
  mkKdeDerivation,
  libcanberra,
}:
mkKdeDerivation {
  pname = "knotifyconfig";

  extraBuildInputs = [ libcanberra ];
}
