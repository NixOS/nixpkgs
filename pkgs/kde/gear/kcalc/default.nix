{
  mkKdeDerivation,
  qt5compat,
  gmp,
  libmpc,
  mpfr,
}:
mkKdeDerivation {
  pname = "kcalc";

  extraBuildInputs = [
    qt5compat
    gmp
    libmpc
    mpfr
  ];
  meta.mainProgram = "kcalc";
}
