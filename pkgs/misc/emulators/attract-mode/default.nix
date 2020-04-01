{ expat, fetchFromGitHub, ffmpeg, fontconfig, freetype, libarchive, libjpeg
, libGLU, libGL, openal, pkgconfig, sfml, stdenv, zlib
}:

stdenv.mkDerivation rec {
  pname = "attract-mode";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "mickelson";
    repo = "attract";
    rev = "v${version}";
    sha256 = "16p369j0hanm0l2fiy6h9d9pn0f3qblcy9l39all6h7rfxnhp9ii";
  };

  nativeBuildInputs = [ pkgconfig ];

  patchPhase = ''
    sed -i "s|prefix=/usr/local|prefix=$out|" Makefile
  '';

  buildInputs = [
    expat ffmpeg fontconfig freetype libarchive libjpeg libGLU libGL openal sfml zlib
  ];

  meta = with stdenv.lib; {
    description = "A frontend for arcade cabinets and media PCs";
    homepage = http://attractmode.org;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = with platforms; linux;
  };
}
