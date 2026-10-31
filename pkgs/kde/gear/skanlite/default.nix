{
  mkKdeDerivation,
  qt5compat,
}:
mkKdeDerivation {
  pname = "skanlite";

  extraBuildInputs = [ qt5compat ];
  meta.mainProgram = "skanlite";
}
