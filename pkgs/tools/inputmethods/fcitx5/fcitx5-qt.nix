{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, qtx11extras
, libxcb
, libXdmcp
, qtbase
, qt6
}:

mkDerivation rec {
  pname = "fcitx5-qt";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-LWOELt1uo5TtM85ppxt6MK7fvUuocHkWXYjUE1yyOV4=";
  };

  preConfigure = ''
    substituteInPlace qt5/platforminputcontext/CMakeLists.txt \
      --replace \$"{CMAKE_INSTALL_QT5PLUGINDIR}" $out/${qtbase.qtPluginPrefix}
    substituteInPlace qt6/platforminputcontext/CMakeLists.txt \
      --replace \$"{CMAKE_INSTALL_QT6PLUGINDIR}" $out/${qt6.qtbase.qtPluginPrefix}
  '';

  cmakeFlags = [
    # adding qt6 to buildInputs would result in error: detected mismatched Qt dependencies
    "-DCMAKE_PREFIX_PATH=${qt6.qtbase}"
    "-DENABLE_QT4=0"
    "-DENABLE_QT6=1"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    fcitx5
    qtx11extras
    libxcb
    libXdmcp
  ];

  meta = with lib; {
    description = "Fcitx5 Qt Library";
    homepage = "https://github.com/fcitx/fcitx5-qt";
    license = with licenses; [ lgpl21Plus bsd3 ];
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
