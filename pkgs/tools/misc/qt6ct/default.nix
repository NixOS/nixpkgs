{
  lib,
  stdenv,
  fetchFromGitLab,
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

  src = fetchFromGitLab {
    domain = "www.opencode.net";
    owner = "trialuser";
    repo = "qt6ct";
    tag = finalAttrs.version;
    hash = "sha256-o2k/b4AGiblS1CkNInqNrlpM1Y7pydIJzEVgVd3ao50=";
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
    homepage = "https://www.opencode.net/trialuser/qt6ct";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      Flakebi
      Scrumplex
    ];
    mainProgram = "qt6ct";
  };
})
