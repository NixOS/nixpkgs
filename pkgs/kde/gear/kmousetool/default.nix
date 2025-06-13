{
  mkKdeDerivation,
  qtmultimedia,
  xorg,
}:
mkKdeDerivation {
  pname = "kmousetool";

  extraNativeBuildInputs = [ qtmultimedia ];
  extraBuildInputs = [ xorg.libXt ];
  meta.mainProgram = "kmousetool";
}
