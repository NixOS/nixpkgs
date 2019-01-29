{ stdenv
, cairo
, cmake
, fetchFromGitHub
, ffmpeg
, gettext
, libGLU_combined
, openal
, pkgconfig
, SDL2
, sfml
, zip
, zlib
}:

stdenv.mkDerivation rec {
  name = "visualboyadvance-m-${version}";
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "visualboyadvance-m";
    repo = "visualboyadvance-m";
    rev = "v${version}";
    sha256 = "1dppfvy24rgg3h84gv33l1y7zznkv3zxn2hf98w85pca6k1y2afz";
  };

  buildInputs = [
    cairo
    cmake
    ffmpeg
    gettext
    libGLU_combined
    openal
    pkgconfig
    SDL2
    sfml
    zip
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='Release'"
    "-DENABLE_FFMPEG='true'"
    "-DENABLE_LINK='true'"
    "-DSYSCONFDIR=etc"
    "-DENABLE_WX='false'"
    "-DENABLE_SDL='true'"
  ];

  meta = {
    description = "A merge of the original Visual Boy Advance forks";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.lassulus ];
    homepage = http://vba-m.com/;
    platforms = stdenv.lib.platforms.linux;
  };
}
