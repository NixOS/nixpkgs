{
  mkKdeDerivation,
  qtmultimedia,
  libvlc,
}:
mkKdeDerivation {
  pname = "elisa";

  extraNativeBuildInputs = [ qtmultimedia ];

  extraBuildInputs = [
    qtmultimedia
    libvlc
  ];

  meta.mainProgram = "elisa";
}
