{
  mkKdeDerivation,
  qtsvg,
  qtwayland,
  wayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "libplasma";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtsvg qtwayland wayland];
}
