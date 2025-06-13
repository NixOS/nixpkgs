{
  mkKdeDerivation,
  qtmultimedia,
  xorg,
}:
mkKdeDerivation {
  pname = "kmousetool";

  extraNativeBuildInputs = [ qtmultimedia ];

  extraBuildInputs = [
    qtmultimedia
    xorg.libXt
  ];

  meta.mainProgram = "kmousetool";
}
