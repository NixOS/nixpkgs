{
  mkKdeDerivation,
  libxxf86vm,
}:
mkKdeDerivation {
  pname = "kgamma";

  extraBuildInputs = [ libxxf86vm ];
}
