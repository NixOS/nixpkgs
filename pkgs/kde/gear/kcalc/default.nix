{
  mkKdeDerivation,
  qt5compat,
  gmp,
  libmpc,
  mpfr,
  kdoctools,
}:
mkKdeDerivation {
  pname = "kcalc";

  extraBuildInputs = [
    qt5compat
    gmp
    libmpc
    mpfr
    kdoctools
  ];
  meta.mainProgram = "kcalc";
}
