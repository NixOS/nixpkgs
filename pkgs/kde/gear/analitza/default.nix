{
  mkKdeDerivation,
  qt5compat,
  qtsvg,
  qtdeclarative,
  eigen,
}:
mkKdeDerivation {
  pname = "analitza";

  extraNativeBuildInputs = [
    qt5compat
    qtsvg
  ];
  extraBuildInputs = [
    qtdeclarative
    eigen
  ];
}
