{ fetchFromGitHub, lib, stdenv, gtk2, pkg-config, qmake, qtbase, unstableGitUpdater }:

stdenv.mkDerivation (finalAttrs: {
  pname = "qt6gtk2";
  version = "0.2-unstable-2024-05-06";

  src = fetchFromGitHub {
    owner = "trialuser02";
    repo = finalAttrs.pname;
    rev = "d29ba6c1fb4ac933ed7b91f0480cbd0c5a975ab8";
    hash = "sha256-lIUCdfsmvuzDQaOi2U/CHch1re6Jn6yDfcX26Gu0eUo=";
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
})
