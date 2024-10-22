{
  mkKdeDerivation,
  qtdeclarative,
  pkg-config,
}:
mkKdeDerivation {
  pname = "kpublictransport";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ qtdeclarative ];
}
