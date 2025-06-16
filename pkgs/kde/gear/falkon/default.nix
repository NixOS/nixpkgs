{
  mkKdeDerivation,
  extra-cmake-modules,
  qtwebchannel,
  qtwebengine,
  python3Packages,
}:
mkKdeDerivation {
  pname = "falkon";

  extraNativeBuildInputs = [
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
