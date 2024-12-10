{
  mkKdeDerivation,
  qtdeclarative,
  qqc2-desktop-style,
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

  extraNativeBuildInputs = [
    pkg-config
    bison
    flex
  ];
  extraBuildInputs = [
    qtdeclarative
    qqc2-desktop-style
    kirigami-addons
    gmp
    mpfr
    libqalculate
  ];
  meta.mainProgram = "kalk";
}
