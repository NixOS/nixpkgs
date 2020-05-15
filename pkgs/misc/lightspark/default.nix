{ stdenv, fetchFromGitHub, pkgconfig, cmake, curl, zlib, ffmpeg, glew, pcre
, rtmpdump, cairo, boost, SDL2, SDL2_mixer, libjpeg, gnome2, lzma, nasm
, llvm, glibmm
}:

stdenv.mkDerivation rec {
  pname = "lightspark";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "lightspark";
    repo = "lightspark";
    rev = version;
    sha256 = "04wn6d6gmpf848x0yghw26m9syv0hm6q5dwqiw3fxhs155jjqfgv";
  };

  patchPhase = ''
    sed -i 's/SET(ETCDIR "\/etc")/SET(ETCDIR "etc")/g' CMakeLists.txt
  '';

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [
    curl zlib ffmpeg glew pcre rtmpdump cairo boost SDL2 SDL2_mixer libjpeg
    gnome2.pango lzma nasm llvm glibmm
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open source Flash Player implementation";
    homepage = "https://lightspark.github.io/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jchw ];
    platforms = platforms.linux;
  };
}
