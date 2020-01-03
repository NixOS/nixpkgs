{ stdenv, fetchFromGitHub, pkgconfig, cmake, curl, zlib, ffmpeg, glew, pcre
, rtmpdump, cairo, boost, SDL2, SDL2_mixer, libjpeg, gnome2, lzma, nasm
, llvm_39, glibmm
}:

stdenv.mkDerivation rec {
  pname = "lightspark";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "lightspark";
    repo = "lightspark";
    rev = version;
    sha256 = "0chydd516wfi73n8dvivk6nwxb9kjimdfghyv9sffmqmza0mv13s";
  };

  patchPhase = ''
    sed -i 's/SET(ETCDIR "\/etc")/SET(ETCDIR "etc")/g' CMakeLists.txt
  '';

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [
    curl zlib ffmpeg glew pcre rtmpdump cairo boost SDL2 SDL2_mixer libjpeg
    gnome2.pango lzma nasm llvm_39 glibmm
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
