{
  mkKdeDerivation,
  qtwebengine,
}:
mkKdeDerivation {
  pname = "messagelib";

  extraPropagatedBuildInputs = [qtwebengine];
}
