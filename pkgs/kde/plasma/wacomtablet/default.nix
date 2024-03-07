{
  mkKdeDerivation,
  pkg-config,
  libwacom,
  xf86_input_wacom,
}:
mkKdeDerivation {
  pname = "wacomtablet";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [libwacom xf86_input_wacom];
}
