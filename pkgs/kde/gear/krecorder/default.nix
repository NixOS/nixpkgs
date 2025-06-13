{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "krecorder";

  extraNativeBuildInputs = [ qtmultimedia ];
  meta.mainProgram = "krecorder";
}
