{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
  wayland,
}:
mkKdeDerivation {
  pname = "kguiaddons";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtwayland wayland];
}
