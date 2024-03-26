{
  mkKdeDerivation,
  qtconnectivity,
  qtmultimedia,
  qtwayland,
  pkg-config,
  wayland,
  wayland-protocols,
  libfakekey,
}:
mkKdeDerivation {
  pname = "kdeconnect-kde";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtconnectivity qtmultimedia qtwayland wayland wayland-protocols libfakekey];

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtwayland}/libexec/qtwaylandscanner"
  ];
}
