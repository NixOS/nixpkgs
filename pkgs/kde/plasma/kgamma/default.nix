{
  mkKdeDerivation,
  xorg,
}:
mkKdeDerivation {
  pname = "kgamma";

  extraBuildInputs = [ xorg.libXxf86vm ];
}
