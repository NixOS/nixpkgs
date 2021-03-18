{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
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
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-qt";
    rev = version;
    sha256 = "sha256-zKGx/lAZeTHkbvADodSuMi69rjNYSdlhp29b/v8XXjA=";
  };

  patches = [
    # Fix missing includes.
    (fetchpatch {
      url = "https://github.com/fcitx/fcitx5-qt/commit/921901a122cbecc5f34fca6b167b63e8ccb8ac39.patch";
      sha256 = "sha256-RmS9KSTJCgd8q4NuGFBtk4xvLqoFXmcaUDVPWVjrUhs=";
    })
    # Fix compatibility with Qt 5.12
    (fetchpatch {
      url = "https://github.com/fcitx/fcitx5-qt/commit/2f6db731cc6c873a08aefe31ff81f11c64fe7ded.patch";
      sha256 = "sha256-PXkaLcFkhOylnzKWcdLvGloqbS1BHMNSr8f46AvuAiM=";
    })
  ];

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
