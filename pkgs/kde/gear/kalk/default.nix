{
  mkKdeDerivation,
  qtdeclarative,
  kirigami-addons,
  pkg-config,
  bison,
  flex,
  gmp,
  mpfr,
  libqalculate,
}:
mkKdeDerivation {
  pname = "kalk";

  extraNativeBuildInputs = [pkg-config bison flex];
  extraBuildInputs = [
    qtdeclarative
    kirigami-addons
    gmp
    mpfr
    libqalculate
  ];
  meta.mainProgram = "kalk";
}
