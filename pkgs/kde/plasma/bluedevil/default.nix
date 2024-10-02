{
  mkKdeDerivation,
  shared-mime-info,
}:
mkKdeDerivation {
  pname = "bluedevil";

  extraNativeBuildInputs = [ shared-mime-info ];
}
