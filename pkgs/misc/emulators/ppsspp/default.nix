{ SDL2
, cmake
, fetchFromGitHub
, ffmpeg_3
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
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-W41Poq5S+opkasIGYo13SQZWQF1HjfFnH7u9DW5HNA0=";
  };

  postPatch = ''
    substituteInPlace git-version.cmake --replace unknown ${src.rev}
    substituteInPlace UI/NativeApp.cpp --replace /usr/share $out/share
  '';

  nativeBuildInputs = [ cmake pkgconfig python3 ];

  buildInputs = [
    SDL2
    ffmpeg_3
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
    "-DHEADLESS=OFF"
  ];

  installPhase = ''
    mkdir -p $out/share/ppsspp
    install -Dm555 PPSSPPQt $out/bin/ppsspp
    mv assets $out/share/ppsspp
  '';

  meta = with lib; {
    description = "A HLE Playstation Portable emulator, written in C++";
    homepage = "https://www.ppsspp.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO: add SDL headless port
