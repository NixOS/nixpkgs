{
  mkKdeDerivation,
  libxxf86vm,
}:
mkKdeDerivation {
  pname = "kgamma";

  outputs = [
    "out"
    "doc"
  ];

  extraBuildInputs = [ libxxf86vm ];
}
