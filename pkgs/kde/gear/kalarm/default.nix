{
  mkKdeDerivation,
  libcanberra,
}:
mkKdeDerivation {
  pname = "kalarm";

  extraBuildInputs = [libcanberra];
}
