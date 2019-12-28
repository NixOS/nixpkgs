{ stdenv
, cairo
, cmake
, fetchFromGitHub
, ffmpeg
, gettext
, libGLU, libGL
, openal
, pkgconfig
, SDL2
, sfml
, zip
, zlib
}:

stdenv.mkDerivation rec {
  pname = "visualboyadvance-m";
  version = "2019-12-26";
  src = fetchFromGitHub {
    owner = "visualboyadvance-m";
    repo = "visualboyadvance-m";
    rev = "d3397e6a1a777ca037c014510689b75da9e197db";
    sha256 = "079cn76sif5jzdl5xpa4rv6iyx4z3xp9fv2nzdbxqgdwi8dh0dr8";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    cairo
    ffmpeg
    gettext
    libGLU libGL
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

  meta =  with stdenv.lib; {
    description = "A merge of the original Visual Boy Advance forks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lassulus ];
    homepage = http://vba-m.com/;
    platforms = stdenv.lib.platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
