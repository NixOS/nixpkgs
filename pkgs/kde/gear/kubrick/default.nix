{
  mkKdeDerivation,
  qtsvg,
  libGLU,
}:
mkKdeDerivation {
  pname = "kubrick";

  extraBuildInputs = [qtsvg libGLU];
}
