{
  mkKdeDerivation,
  qtsvg
}:
mkKdeDerivation {
  pname = "dolphin";
  
  extraBuildInputs = [qtsvg];
}
