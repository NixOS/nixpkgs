{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "ktuberling";

  extraBuildInputs = [qtmultimedia];
  meta.mainProgram = "ktuberling";
}
