{ stdenv, fetchurl, pkgconfig, intltool, glib, libxml2
, libxslt, libarchive, bzip2, lzma
}:

stdenv.mkDerivation rec {
  name = "osinfo-db-tools-1.2.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${name}.tar.gz";
    sha256 = "07zqbwsmdgnzqah2smm4zri04c0qm82z1jn8kzz1bnsqbfg84l1v";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ glib libxml2 libxslt libarchive bzip2 lzma ];

  meta = with stdenv.lib; {
    description = "Tools for managing the osinfo database";
    homepage = https://libosinfo.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
