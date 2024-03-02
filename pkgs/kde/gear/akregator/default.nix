{
  mkKdeDerivation,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "akregator";

  extraBuildInputs = [qtwebengine];
}
