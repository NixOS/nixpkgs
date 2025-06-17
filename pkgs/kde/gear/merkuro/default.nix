{
  mkKdeDerivation,
  qtlocation,
  qtsvg,
  libplasma,
}:
mkKdeDerivation {
  pname = "merkuro";

  extraNativeBuildInputs = [ qtlocation ];

  extraBuildInputs = [
    qtlocation
    qtsvg
    libplasma
  ];
}
