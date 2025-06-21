{
  fetchFromGitLab,
  lib,
  stdenv,
  gtk2,
  pkg-config,
  qmake,
  qtbase,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "qt6gtk2";
  version = "0.5-unstable-2025-06-08";

  src = fetchFromGitLab {
    domain = "opencode.net";
    owner = "trialuser";
    repo = "qt6gtk2";
    rev = "8e019e8b67b4022d15a6c1344e42ca5b9bb9df40";
    hash = "sha256-G2TQ4LU8Cmvd+u6/s1ugbUkZcRXHTBm3+ISY0g/5/60=";
  };

  buildInputs = [
    gtk2
    qtbase
  ];
  nativeBuildInputs = [
    pkg-config
    qmake
  ];

  dontWrapQtApps = true;

  qmakeFlags = [
    "PLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "GTK+2.0 integration plugins for Qt6";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/trialuser02/qt6gtk2";
    maintainers = [ lib.maintainers.misterio77 ];
    platforms = lib.platforms.linux;
  };
}
