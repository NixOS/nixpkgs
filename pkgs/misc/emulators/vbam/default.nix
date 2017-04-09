{ stdenv
, cairo
, cmake
, fetchsvn
, ffmpeg
, gettext
, libpng
, libpthreadstubs
, libXdmcp
, libxshmfence
, mesa
, openal
, pkgconfig
, SDL
, wxGTK
, zip
, zlib
}:

stdenv.mkDerivation {
  name = "VBAM-1507";
  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/vbam/code/trunk";
    rev = 1507;
    sha256 = "0fqvgi5s0sacqr9yi7kv1klqlvfzr13sjq5ikipirz0jv50kjxa7";
  };

  buildInputs = [
    cairo
    cmake
    ffmpeg
    gettext
    libpng
    libpthreadstubs
    libXdmcp
    libxshmfence
    mesa
    openal
    pkgconfig
    SDL
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
