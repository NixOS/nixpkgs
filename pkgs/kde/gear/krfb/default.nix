{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
  libvncserver,
  pipewire,
  xorg,
}:
mkKdeDerivation {
  pname = "krfb";

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtwayland}/libexec/qtwaylandscanner"
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwayland
    libvncserver
    pipewire
    xorg.libXdamage
  ];
}
