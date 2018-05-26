{ stdenv, fetchurl, pkgconfig, intltool, glib, libxml2
, libxslt, libarchive, bzip2, lzma
}:

stdenv.mkDerivation rec {
  name = "osinfo-db-tools-1.1.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${name}.tar.gz";
    sha256 = "0sslzrbhpb2js1vn48c11s5p0bic3yqzdnxm054dhc3wq0pwshd1";
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
