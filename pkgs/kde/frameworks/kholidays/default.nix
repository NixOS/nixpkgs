{
  mkKdeDerivation,
  qttools,
  qtdeclarative,
  bison,
  flex,
}:
mkKdeDerivation {
  pname = "kholidays";

  extraNativeBuildInputs = [
    qttools

    bison
    flex
  ];
  extraBuildInputs = [ qtdeclarative ];
}
