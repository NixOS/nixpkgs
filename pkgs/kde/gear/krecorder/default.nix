{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "krecorder";

  extraNativeBuildInputs = [ qtmultimedia ];
  extraBuildInputs = [ qtmultimedia ];

  meta.mainProgram = "krecorder";
}
