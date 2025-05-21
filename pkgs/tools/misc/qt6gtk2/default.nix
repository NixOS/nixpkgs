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
  version = "0.5-unstable-2025-03-04";

  src = fetchFromGitLab {
    domain = "opencode.net";
    owner = "trialuser";
    repo = "qt6gtk2";
    rev = "d7c14bec2c7a3d2a37cde60ec059fc0ed4efee67";
    hash = "sha256-6xD0lBiGWC3PXFyM2JW16/sDwicw4kWSCnjnNwUT4PI=";
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
