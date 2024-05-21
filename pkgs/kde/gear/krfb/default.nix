{
  mkKdeDerivation,
  qtwayland,
  libvncserver,
  xorg,
}:
mkKdeDerivation {
  pname = "krfb";

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtwayland}/libexec/qtwaylandscanner"
  ];

  extraBuildInputs = [qtwayland libvncserver xorg.libXdamage];
}
