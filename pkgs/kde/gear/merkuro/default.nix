{
  mkKdeDerivation,
  qtlocation,
  qtsvg,
  libplasma,
}:
mkKdeDerivation {
  pname = "merkuro";

  extraBuildInputs = [
    qtlocation
    qtsvg
    libplasma
  ];
}
