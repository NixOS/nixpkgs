{
  mkKdeDerivation,
  pkg-config,
  modemmanager,
}:
mkKdeDerivation {
  pname = "modemmanager-qt";

  extraNativeBuildInputs = [pkg-config];
  extraPropagatedBuildInputs = [modemmanager];
}
