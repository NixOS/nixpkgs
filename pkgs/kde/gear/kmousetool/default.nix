{
  mkKdeDerivation,
  qtmultimedia,
  libxt,
}:
mkKdeDerivation {
  pname = "kmousetool";

  extraBuildInputs = [
    qtmultimedia
    libxt
  ];
  meta.mainProgram = "kmousetool";
}
