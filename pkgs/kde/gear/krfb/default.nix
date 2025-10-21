{
  mkKdeDerivation,
  pkg-config,
  qtbase,
  libvncserver,
  pipewire,
  xorg,
}:
mkKdeDerivation {
  pname = "krfb";

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtbase}/libexec/qtwaylandscanner"
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    libvncserver
    pipewire
    xorg.libXdamage
  ];
}
