{ stdenv, fetchurl, pkgconfig, intltool, glib, libxml2
, libxslt, libarchive, bzip2, lzma, json-glib
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db-tools";
  version = "1.5.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.gz";
    sha256 = "1pihjwajmahldxi3isnq6wcsbwj0hsnq8z5kp3w4j615ygrn0cgl";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ glib json-glib libxml2 libxslt libarchive bzip2 lzma ];

  meta = with stdenv.lib; {
    description = "Tools for managing the osinfo database";
    homepage = https://libosinfo.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
