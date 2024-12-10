{
  mkKdeDerivation,
  fetchpatch,
  qtwayland,
  libvncserver,
  xorg,
}:
mkKdeDerivation {
  pname = "krfb";

  # Backports.
  # FIXME: remove in next release
  patches = [
    # Build fix for Qt 6.7.1
    ./fix-build-with-qt-6.7.1.diff
    # Wayland crash fix
    (fetchpatch {
      url = "https://invent.kde.org/network/krfb/-/commit/6e7a5ba56966ea1b67400be9ab7c82885abb76be.diff";
      hash = "sha256-kqD4B2Nixw8KMCOc4RpoEmvII2JZYBPxog6TT/BPuFs=";
    })
  ];

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtwayland}/libexec/qtwaylandscanner"
  ];

  extraBuildInputs = [
    qtwayland
    libvncserver
    xorg.libXdamage
  ];
}
