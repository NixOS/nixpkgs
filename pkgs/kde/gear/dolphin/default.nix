{
  mkKdeDerivation,
  qtwayland
}:
mkKdeDerivation {
  pname = "dolphin";

  extraBuildInputs = [qtwayland];
}
