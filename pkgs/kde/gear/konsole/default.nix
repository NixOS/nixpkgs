{
  mkKdeDerivation,
  qt5compat,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "konsole";

  extraNativeBuildInputs = [ qtmultimedia ];
  extraBuildInputs = [ qt5compat ];

  meta.mainProgram = "konsole";
}
