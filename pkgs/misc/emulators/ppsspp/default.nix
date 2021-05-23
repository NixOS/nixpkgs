{ mkDerivation
, fetchFromGitHub
, fetchpatch
, SDL2
, cmake
, ffmpeg
, glew
, lib
, libzip
, pkg-config
, python3
, qtbase
, qtmultimedia
, snappy
, zlib
}:

mkDerivation rec {
  pname = "ppsspp";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-vfp/vacIItlPP5dR7jzDT7oOUNFnjvvdR46yi79EJKU=";
  };

  patches = [
    # adds ffmpeg 4.3 compatibility, remove for ppsspp 1.12
    (fetchpatch {
      url = "https://github.com/hrydgard/ppsspp/commit/8a69c3d1226fe174c49437514a2d3ca7e411c3fa.patch";
      sha256 = "sha256-ecDoOydaLfL6+eFpahcO1TnRl866mZZVHlr6Qrib1mo=";
    })
  ];

  postPatch = ''
    substituteInPlace git-version.cmake --replace unknown ${src.rev}
    substituteInPlace UI/NativeApp.cpp --replace /usr/share $out/share
  '';

  nativeBuildInputs = [ cmake pkg-config python3 ];

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
    "-DHEADLESS=OFF"
    "-DOpenGL_GL_PREFERENCE=GLVND"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_SYSTEM_LIBZIP=ON"
    "-DUSE_SYSTEM_SNAPPY=ON"
    "-DUSING_QT_UI=ON"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/ppsspp
    install -Dm555 PPSSPPQt $out/bin/ppsspp
    mv assets $out/share/ppsspp
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.ppsspp.org/";
    description = "A HLE Playstation Portable emulator, written in C++";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO: add SDL headless port
