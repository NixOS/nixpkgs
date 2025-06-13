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
    qtsvg
    libplasma
  ];
}
