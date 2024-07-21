{
  mkKdeDerivation,
  qt5compat,
  gmp,
  mpfr,
  kdoctools,
}:
mkKdeDerivation {
  pname = "kcalc";

  extraBuildInputs = [qt5compat gmp mpfr kdoctools];
  meta.mainProgram = "kcalc";
}
