{
  mkKdeDerivation,
  qtdeclarative,
  qtlocation,
  pkg-config,
}:
mkKdeDerivation {
  pname = "kpublictransport";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtdeclarative
    qtlocation
  ];
}
