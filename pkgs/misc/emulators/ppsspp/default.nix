{ SDL2
, cmake
, fetchFromGitHub
, ffmpeg
, glew
, lib
, libzip
, mkDerivation
, pkgconfig
, python3
, qtbase
, qtmultimedia
, snappy
, zlib
}:

mkDerivation rec {
  pname = "ppsspp";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = "ppsspp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0ivi0dcfxwa4nz19amki80qacnjhqr42f0ihyby1scxafl3nq55c";
  };

  postPatch = ''
    substituteInPlace git-version.cmake \
      --replace unknown ${src.rev}
    substituteInPlace UI/NativeApp.cpp \
      --replace /usr/share $out/share
  '';

  nativeBuildInputs = [ cmake pkgconfig python3 ];

  buildInputs = [
    SDL2
    ffmpeg
    glew
    libzip
    qtbase
    qtmultimedia
    snappy
    zlib
  ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=GLVND"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_SYSTEM_LIBZIP=ON"
    "-DUSE_SYSTEM_SNAPPY=ON"
    "-DUSING_QT_UI=ON"
  ];

  installPhase = ''
    mkdir -p $out/share/ppsspp
    install -Dm555 PPSSPPQt $out/bin/ppsspp
    mv assets $out/share/ppsspp
  '';

  meta = with lib; {
    description = "A PSP emulator for Android, Windows, Mac and Linux, written in C++";
    homepage = "https://www.ppsspp.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
