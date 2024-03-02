{
  mkKdeDerivation,
  qtmultimedia,
  vlc,
}:
mkKdeDerivation {
  pname = "elisa";

  extraBuildInputs = [qtmultimedia vlc];
}
