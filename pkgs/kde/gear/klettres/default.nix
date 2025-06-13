{
  mkKdeDerivation,
  qtmultimedia,
  qtsvg,
}:
mkKdeDerivation {
  pname = "klettres";

  extraNativeBuildInputs = [ qtmultimedia ];
  extraBuildInputs = [ qtsvg ];

  meta.mainProgram = "klettres";
}
