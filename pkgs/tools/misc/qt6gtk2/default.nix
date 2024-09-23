{ fetchFromGitHub, lib, stdenv, gtk2, pkg-config, qmake, qtbase, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "qt6gtk2";
  version = "0.2-unstable-2024-08-14";

  src = fetchFromGitHub {
    owner = "trialuser02";
    repo = "qt6gtk2";
    rev = "b574ba5b59edf5ce220ca304e1d07d75c94d03a2";
    hash = "sha256-2NzUmcNJBDUJqcBUF4yRO/mDqDf1Up1k9cuMxVUqe60=";
  };

  buildInputs = [ gtk2 qtbase ];
  nativeBuildInputs = [ pkg-config qmake ];

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
