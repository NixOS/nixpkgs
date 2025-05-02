{
  mkKdeDerivation,
  qt5compat,
  gmp,
  mpfr,
  kdoctools,
}:
mkKdeDerivation {
  pname = "kcalc";

  extraNativeBuildInputs = [kdoctools];
  extraBuildInputs = [qt5compat gmp mpfr];
  meta.mainProgram = "kcalc";
}
