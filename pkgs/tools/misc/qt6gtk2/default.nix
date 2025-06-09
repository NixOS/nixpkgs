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
  version = "0.4-unstable-2025-05-11";

  src = fetchFromGitLab {
    domain = "opencode.net";
    owner = "trialuser";
    repo = "qt6gtk2";
    rev = "a95d620193bfc3a2d5e17c3d1c883849182f77b8";
    hash = "sha256-gcCujWImw7WOnz7QI4h4ye/v5EZWVIq5eFLYoOxYoog=";
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
