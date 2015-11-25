{ stdenv, fetchurl
, mesa, cmake, lua5, SDL, openal, libvorbis, libogg, zlib, physfs
, freetype, libpng, libjpeg, glew, wxGTK28, libxml2, libpthreadstubs
}:

stdenv.mkDerivation rec {
  name = "glestae-${version}";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/glestae/${version}/glestae-src-${version}.tar.bz2";
    sha256 = "1k02vf88mms0zbprvy1b1qdwjzmdag5rd1p43f0gpk1sms6isn94";
  };

  buildInputs =
    [ mesa cmake lua5 SDL openal libvorbis libogg zlib physfs
      freetype libpng libjpeg glew wxGTK28 libxml2 libpthreadstubs
    ];

  cmakeFlags = [
    "-DLUA_LIBRARIES=-llua"
    "-DGAE_DATA_DIR=$out/share/glestae"
  ];

  meta = {
    description = "A 3D RTS - fork of inactive Glest project";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    # Note that some data seems to be under separate redistributable licenses
    license = stdenv.lib.licenses.gpl2Plus;
    broken = true;
    downloadPage = "http://sourceforge.net/projects/glestae/files/0.3.2/";
  };
}
