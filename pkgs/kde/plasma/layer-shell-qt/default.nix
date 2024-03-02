{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
  wayland,
  wayland-protocols,
}:
mkKdeDerivation {
  pname = "layer-shell-qt";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtwayland wayland wayland-protocols];
}
