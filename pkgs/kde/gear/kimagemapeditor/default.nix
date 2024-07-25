{
  mkKdeDerivation,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "kimagemapeditor";

  extraBuildInputs = [qtwebengine];
  meta.mainProgram = "kimagemapeditor";
}
