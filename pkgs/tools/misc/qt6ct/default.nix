{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qtsvg,
  qtwayland,
  qmake,
  qttools,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qt6ct";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "ilya-fedin";
    repo = "qt6ct";
    tag = finalAttrs.version;
    hash = "sha256-ePY+BEpEcAq11+pUMjQ4XG358x3bXFQWwI1UAi+KmLo=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    qtwayland
  ];

  qmakeFlags = [
    "LRELEASE_EXECUTABLE=${lib.getDev qttools}/bin/lrelease"
    "PLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  meta = {
    description = "Qt6 Configuration Tool";
    homepage = "https://github.com/ilya-fedin/qt6ct";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      Flakebi
      Scrumplex
    ];
    mainProgram = "qt6ct";
  };
})
