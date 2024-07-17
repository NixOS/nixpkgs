{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  curl,
  zlib,
  ffmpeg,
  glew,
  pcre,
  rtmpdump,
  cairo,
  boost,
  SDL2,
  libjpeg,
  pango,
  xz,
  nasm,
  llvm,
  glibmm,
}:

stdenv.mkDerivation rec {
  pname = "lightspark";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "lightspark";
    repo = "lightspark";
    rev = version;
    hash = "sha256-qX/ft9slWTbvuSyi2jB6YC7D7QTtCybL/dTo1dJp3pQ=";
  };

  postPatch = ''
    sed -i 's/SET(ETCDIR "\/etc")/SET(ETCDIR "etc")/g' CMakeLists.txt
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    curl
    zlib
    ffmpeg
    glew
    pcre
    rtmpdump
    cairo
    boost
    SDL2
    libjpeg
    pango
    xz
    nasm
    llvm
    glibmm
  ];

  meta = with lib; {
    description = "Open source Flash Player implementation";
    homepage = "https://lightspark.github.io/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jchw ];
    platforms = platforms.linux;
    mainProgram = "lightspark";
  };
}
