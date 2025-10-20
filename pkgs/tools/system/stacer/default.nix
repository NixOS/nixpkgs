{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qttools,
  wrapQtAppsHook,
  qtcharts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stacer";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "oguzhaninan";
    repo = "stacer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ta9Kvpw/aVcrXvqclGyTKRiJ1J4CCMz3VUsZvOb/zWI=";
  };

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=4.0"
  ];

  postPatch = ''
    substituteInPlace stacer/Managers/app_manager.cpp \
      --replace-fail 'qApp->applicationDirPath() + "/translations"' \
                'QStandardPaths::locate(QStandardPaths::AppDataLocation, "translations", QStandardPaths::LocateDirectory)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtcharts
  ];

  preConfigure = ''
    lrelease stacer/stacer.pro
  '';

  postInstall = ''
    install -Dm644 ../translations/*.qm -t $out/share/stacer/translations
  '';

  meta = {
    description = "Linux System Optimizer and Monitoring";
    homepage = "https://github.com/oguzhaninan/stacer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dit7ya ];
    platforms = lib.platforms.linux;
    mainProgram = "stacer";
  };
})
