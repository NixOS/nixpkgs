{ fetchFromGitHub, lib, stdenv, gtk2, pkg-config, qmake, qtbase, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "qt6gtk2";
  version = "0.2-unstable-2024-06-22";

  src = fetchFromGitHub {
    owner = "trialuser02";
    repo = "qt6gtk2";
    rev = "2e8729481649d0a2fd4cc07051daf6134809d2c5";
    hash = "sha256-j1PFJEGCd2snQ6bAcsmFNrupoZg+ib/08Xs1oJyWyN0=";
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
