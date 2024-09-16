{
  mkKdeDerivation,
  qtmultimedia,
  xorg,
}:
mkKdeDerivation {
  pname = "kmousetool";

  extraBuildInputs = [qtmultimedia xorg.libXt];
  meta.mainProgram = "kmousetool";
}
