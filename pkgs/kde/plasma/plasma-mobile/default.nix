{
  mkKdeDerivation,
  pkg-config,
  qtsensors,
}:
mkKdeDerivation {
  pname = "plasma-mobile";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtsensors];
}
