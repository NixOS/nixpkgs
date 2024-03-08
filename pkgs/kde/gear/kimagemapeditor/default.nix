{
  mkKdeDerivation,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "kimagemapeditor";

  extraBuildInputs = [qtwebengine];
}
