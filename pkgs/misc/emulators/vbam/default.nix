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
  version = "2.1.3";
  src = fetchFromGitHub {
    owner = "visualboyadvance-m";
    repo = "visualboyadvance-m";
    rev = "v${version}";
    sha256 = "0ibpn05jm6zvvrjyxbmh8qwm1qd26v0dzq45cp233ksvapw1h77h";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    cairo
    ffmpeg
    gettext
    libGLU_combined
    openal
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
