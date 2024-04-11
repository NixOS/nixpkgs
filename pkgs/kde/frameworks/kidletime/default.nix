{
  mkKdeDerivation,
  qtwayland,
  pkg-config,
  wayland-protocols,
  xorg,
}:
mkKdeDerivation {
  pname = "kidletime";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtwayland xorg.libXScrnSaver wayland-protocols];
}
