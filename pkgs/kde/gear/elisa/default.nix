{
  mkKdeDerivation,
  qtmultimedia,
  libvlc,
}:
mkKdeDerivation {
  pname = "elisa";

  extraNativeBuildInputs = [ qtmultimedia ];
  extraBuildInputs = [ libvlc ];
  meta.mainProgram = "elisa";
}
