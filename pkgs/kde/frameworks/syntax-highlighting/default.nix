{
  mkKdeDerivation,
  qtdeclarative,
  qttools,
  perl,
}:
mkKdeDerivation {
  pname = "syntax-highlighting";

  extraBuildInputs = [qtdeclarative];
  extraNativeBuildInputs = [qttools perl];
}
