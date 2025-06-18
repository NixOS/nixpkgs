{
  mkKdeDerivation,
  qtsvg,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "kclock";

  extraNativeBuildInputs = [ qtmultimedia ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia
  ];
}
