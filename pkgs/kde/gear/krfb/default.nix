{
  mkKdeDerivation,
  pkg-config,
  qtbase,
  libvncserver,
  pipewire,
  libxdamage,
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
    libxdamage
  ];
}
