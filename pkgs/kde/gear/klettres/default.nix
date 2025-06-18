{
  mkKdeDerivation,
  qtmultimedia,
  qtsvg,
}:
mkKdeDerivation {
  pname = "klettres";

  extraNativeBuildInputs = [ qtmultimedia ];

  extraBuildInputs = [
    qtmultimedia
    qtsvg
  ];

  meta.mainProgram = "klettres";
}
