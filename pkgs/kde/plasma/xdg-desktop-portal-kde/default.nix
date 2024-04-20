{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
  wayland,
  wayland-protocols,
  cups,
}:
mkKdeDerivation {
  pname = "xdg-desktop-portal-kde";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtwayland wayland wayland-protocols cups];
}
