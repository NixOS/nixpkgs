{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "kcompletion";

  extraNativeBuildInputs = [qttools];
}
