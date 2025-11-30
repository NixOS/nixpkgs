{
  mkKdeDerivation,
  qtdeclarative,
  pkg-config,
  bison,
  flex,
  gmp,
  mpfr,
  libqalculate,
}:
mkKdeDerivation {
  pname = "kalk";

  extraNativeBuildInputs = [
    pkg-config
    bison
    flex
  ];
  extraBuildInputs = [
    qtdeclarative
    gmp
    mpfr
    libqalculate
  ];
  meta.mainProgram = "kalk";
}
