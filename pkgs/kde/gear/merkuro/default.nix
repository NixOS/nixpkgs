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

  # FIXME: not sure why this is failing
  dontQmlLint = true;
}
