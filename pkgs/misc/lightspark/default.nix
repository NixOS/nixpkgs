{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, curl, zlib, ffmpeg_3, glew, pcre
, rtmpdump, cairo, boost, SDL2, SDL2_mixer, libjpeg, pango, xz, nasm
, llvm, glibmm
}:

stdenv.mkDerivation rec {
  pname = "lightspark";
  version = "0.8.4.1";

  src = fetchFromGitHub {
    owner = "lightspark";
    repo = "lightspark";
    rev = version;
    sha256 = "sha256-pIiv5wEDLvTHjlYSicXUTTI6pVAsO6FC39Gie9Z/hZ4=";
  };

  patchPhase = ''
    sed -i 's/SET(ETCDIR "\/etc")/SET(ETCDIR "etc")/g' CMakeLists.txt
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
    curl zlib ffmpeg_3 glew pcre rtmpdump cairo boost SDL2 SDL2_mixer libjpeg
    pango xz nasm llvm glibmm
  ];

  meta = with lib; {
    description = "Open source Flash Player implementation";
    homepage = "https://lightspark.github.io/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jchw ];
    platforms = platforms.linux;
  };
}
