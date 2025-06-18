{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
  cups,
}:
mkKdeDerivation {
  pname = "xdg-desktop-portal-kde";

  extraNativeBuildInputs = [
    pkg-config
    qtwayland
  ];

  extraBuildInputs = [
    qtwayland
    cups
  ];
}
