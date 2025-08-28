{
  mkKdeDerivation,
  bison,
  flex,
  recastnavigation,
}:
mkKdeDerivation {
  pname = "kosmindoormap";

  extraNativeBuildInputs = [
    bison
    flex
  ];
  extraBuildInputs = [ recastnavigation ];
}
