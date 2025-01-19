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
let
  inherit (lib) getDev;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qt6ct";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "trialuser02";
    repo = "qt6ct";
    rev = finalAttrs.version;
    hash = "sha256-MmN/qPBlsF2mBST+3eYeXaq+7B3b+nTN2hi6CmxrILc=";
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
    "LRELEASE_EXECUTABLE=${getDev qttools}/bin/lrelease"
    "PLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  meta = {
    description = "Qt6 Configuration Tool";
    homepage = "https://github.com/trialuser02/qt6ct";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      Flakebi
      Scrumplex
    ];
    mainProgram = "qt6ct";
  };
})
