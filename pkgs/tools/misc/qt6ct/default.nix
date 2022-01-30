{ stdenv
, lib
, fetchFromGitHub
, qtbase
, qttools
, cmake
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qt6ct";
  version = "2021-12-22";

  src = fetchFromGitHub {
    owner = "trialuser02";
    repo = pname;
    rev = "e41923da5723e310310f183dd28dee64293e00ae";
    sha256 = "1Pclif3CDaDXun0OrWDAQPNTACO9nXu5eNm3AyyDSGE=";
  };

  outputs = [ "out" ];
  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ qtbase qttools ];

  patches = [
    ./fix-cmake-qtpaths.diff # https://github.com/trialuser02/qt6ct/issues/8
    ./set-plugindir-path.diff # https://github.com/trialuser02/qt6ct/issues/9
  ];

  cmakeFlags = [
    "-DPLUGINDIR=${qtbase.qtPluginPrefix}" # -> $out/lib/qt-6.2.2/plugins
  ];

  meta = with lib; {
    description = "Qt6 Configuration Tool";
    homepage = "https://github.com/trialuser02/qt6ct";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ milahu ];
  };
}
