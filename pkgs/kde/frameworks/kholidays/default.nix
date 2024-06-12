{
  mkKdeDerivation,
  qttools,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kholidays";

  extraNativeBuildInputs = [qttools];
  extraBuildInputs = [qtdeclarative];
}
