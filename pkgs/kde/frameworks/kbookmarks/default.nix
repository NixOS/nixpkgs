{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kbookmarks";

  extraNativeBuildInputs = [qttools];
}
