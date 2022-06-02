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
}:

mkDerivation rec {
  pname = "fcitx5-qt";
  version = "5.0.11";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-T3gGErvB1DtEdHSC1oKzmttTLBBn3jXcvZFWnpoPz4E=";
  };

  preConfigure = ''
    substituteInPlace qt5/platforminputcontext/CMakeLists.txt \
      --replace \$"{CMAKE_INSTALL_QT5PLUGINDIR}" $out/${qtbase.qtPluginPrefix}
  '';

  cmakeFlags = [
    "-DENABLE_QT4=0"
    "-DENABLE_QT6=0"
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
