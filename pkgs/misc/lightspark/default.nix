{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, curl, zlib, ffmpeg, glew, pcre
, rtmpdump, cairo, boost, SDL2, SDL2_mixer, libjpeg, pango, xz, nasm
, llvm, glibmm
}:

stdenv.mkDerivation rec {
  pname = "lightspark";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "lightspark";
    repo = "lightspark";
    rev = version;
    sha256 = "sha256-/Nd69YFctLDJ8SM9WvYp6okyPQd6+ob2mBN3sPg+7Ww=";
  };

  postPatch = ''
    sed -i 's/SET(ETCDIR "\/etc")/SET(ETCDIR "etc")/g' CMakeLists.txt
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
    curl zlib ffmpeg glew pcre rtmpdump cairo boost SDL2 SDL2_mixer libjpeg
    pango xz nasm llvm glibmm
  ];

  meta = with lib; {
    description = "Open source Flash Player implementation";
    homepage = "https://lightspark.github.io/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jchw ];
    platforms = platforms.linux;
  };
}
