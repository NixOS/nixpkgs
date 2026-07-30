{
  mkKdeDerivation,
  qt5compat,
}:
mkKdeDerivation {
  pname = "kfind";

  extraBuildInputs = [ qt5compat ];
  meta.mainProgram = "kfind";
}
