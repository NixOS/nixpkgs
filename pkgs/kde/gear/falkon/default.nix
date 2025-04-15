{
  mkKdeDerivation,
  extra-cmake-modules,
  qtwebchannel,
  qtwebengine,
  qttools,
  python3Packages,
}:
mkKdeDerivation {
  pname = "falkon";

  # Fix build with PySide 6.9
  # Submitted upstream: https://invent.kde.org/network/falkon/-/merge_requests/128
  # FIXME: remove when merged
  patches = [ ./qt-6.9.patch ];

  extraNativeBuildInputs = [
    qttools
    qtwebchannel
    qtwebengine
  ];
  extraBuildInputs = [
    extra-cmake-modules
    qtwebchannel
    qtwebengine
    python3Packages.pyside6
  ];
  meta.mainProgram = "falkon";
}
