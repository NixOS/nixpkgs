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
  version = "2.1.1";
  src = fetchFromGitHub {
    owner = "visualboyadvance-m";
    repo = "visualboyadvance-m";
    rev = "v${version}";
    sha256 = "03cs7wn01flx925sxhpz1j5sxa6s7wfxq71955kasn7a3xr1kxwn";
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
