{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtcharts,
  qttools,
  qtsvg,
  qtwayland,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "stacer";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "QuentiumYT";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-sBgq51BqD3/8FC/dkIL/HCitoLC4LRnvkR9UNRRHWmo=";
  };

  postPatch = ''
    substituteInPlace stacer/Managers/app_manager.cpp \
      --replace 'qApp->applicationDirPath() + "/translations"' \
                'QStandardPaths::locate(QStandardPaths::AppDataLocation, "translations", QStandardPaths::LocateDirectory)'
  '';

  buildInputs = [
    qtcharts
    qttools
    qtsvg
    qtwayland
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_COMPILER=g++")
  ];

  preConfigure = ''
    lrelease stacer/stacer.pro
  '';

  postInstall = ''
    install -Dm644 ../translations/*.qm -t $out/share/stacer/translations
  '';

  meta = with lib; {
    description = "Linux System Optimizer and Monitoring";
    homepage = "https://github.com/oguzhaninan/stacer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.linux;
    mainProgram = "stacer";
  };
}
