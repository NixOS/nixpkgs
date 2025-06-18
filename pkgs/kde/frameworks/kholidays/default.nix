{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kholidays";

  extraBuildInputs = [ qtdeclarative ];
}
