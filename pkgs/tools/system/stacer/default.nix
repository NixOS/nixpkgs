{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtcharts,
  qttools,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "stacer";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "oguzhaninan";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qndzzkbq6abapvwq202kva8j619jdn9977sbqmmfs9zkjz4mbsd";
  };

  postPatch = ''
    substituteInPlace stacer/Managers/app_manager.cpp \
      --replace 'qApp->applicationDirPath() + "/translations"' \
                'QStandardPaths::locate(QStandardPaths::AppDataLocation, "translations", QStandardPaths::LocateDirectory)'
  '';

  buildInputs = [
    qtcharts
    qttools
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
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
