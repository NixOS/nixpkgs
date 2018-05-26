{ stdenv
, cairo
, cmake
, fetchFromGitHub
, ffmpeg
, gettext
, gtk2-x11
, libpng
, libpthreadstubs
, libXdmcp
, libxshmfence
, libGLU_combined
, openal
, pkgconfig
, SDL2
, sfml
, wxGTK
, zip
, zlib
}:

stdenv.mkDerivation rec {
  name = "visualboyadvance-m-${version}";
  version = "unstable-2017-09-04";
  src = fetchFromGitHub {
    owner = "visualboyadvance-m";
    repo = "visualboyadvance-m";
    rev = "ceef480";
    sha256 = "1lpmlj8mv6fwlfg9m58hzggx8ld6cnjvaqx5ka5sffxd9v95qq2l";
  };

  buildInputs = [
    cairo
    cmake
    ffmpeg
    gettext
    gtk2-x11
    libGLU_combined
    openal
    pkgconfig
    SDL2
    sfml
    wxGTK
    zip
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='Release'"
    "-DENABLE_FFMPEG='true'"
    #"-DENABLE_LINK='true'" currently broken :/
    "-DSYSCONFDIR=etc"
  ];

  meta = {
    description = "A merge of the original Visual Boy Advance forks";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.lassulus ];
    homepage = http://vba-m.com/;
    platforms = stdenv.lib.platforms.linux;
  };
}
