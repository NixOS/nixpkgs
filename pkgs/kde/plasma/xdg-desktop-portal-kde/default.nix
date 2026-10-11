{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
  cups,
  pipewire,
}:
mkKdeDerivation {
  pname = "xdg-desktop-portal-kde";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwayland
    cups
    pipewire
  ];
}
