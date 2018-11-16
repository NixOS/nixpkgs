{ expat, fetchFromGitHub, ffmpeg, fontconfig, freetype, libarchive, libjpeg
, libGLU_combined, openal, pkgconfig, sfml, stdenv, zlib
}:

stdenv.mkDerivation rec {
  name = "attract-mode-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "mickelson";
    repo = "attract";
    rev = "v${version}";
    sha256 = "1arkfj0q3n1qbq5jwmal0kixxph8lnmv3g9bli36inab4r8zzmp8";
  };

  nativeBuildInputs = [ pkgconfig ];

  patchPhase = ''
    sed -i "s|prefix=/usr/local|prefix=$out|" Makefile
  '';

  buildInputs = [
    expat ffmpeg fontconfig freetype libarchive libjpeg libGLU_combined openal sfml zlib
  ];

  meta = with stdenv.lib; {
    description = "A frontend for arcade cabinets and media PCs";
    homepage = http://attractmode.org;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = with platforms; linux;
  };
}
