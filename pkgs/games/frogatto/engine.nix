{ lib, stdenv, fetchFromGitHub, which
, boost, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf
, glew, zlib, icu, pkg-config, cairo, libvpx }:

stdenv.mkDerivation {
  pname = "anura-engine";
  version = "unstable-2021-05-24";

  src = fetchFromGitHub {
    owner = "anura-engine";
    repo = "anura";
    rev = "ed50bbfa68a4aa09438d95d39103ec39156d438f";
    sha256 = "0bk0qklk9wwx3jr2kbrmansccn1nj962v5n2vlb5hxsrcv96s3dg";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/sys.cpp \
      --replace mallinfo2 mallinfo
  '';

  nativeBuildInputs = [
    which pkg-config
  ];

  buildInputs = [
    boost
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    glew
    zlib
    icu
    cairo
    libvpx
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/frogatto
    cp -ar data images modules $out/share/frogatto/
    cp -a anura $out/bin/frogatto
  '';

  meta = with lib; {
    homepage = "https://github.com/anura-engine/anura";
    description = "Game engine used by Frogatto";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ astro ];
  };
}
