{ stdenv, fetchurl, pkgconfig, gettext, glib, libxml2, perl
, libxslt, libarchive, bzip2, lzma, json-glib, libsoup
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db-tools";
  version = "1.6.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.gz";
    sha256 = "0x155d4hqz7mabgqvgydqjm9d8aabc78vr0v0pnsp9vkdlcv3mfh";
  };

  nativeBuildInputs = [ pkgconfig gettext perl ];
  buildInputs = [ glib json-glib libxml2 libxslt libarchive bzip2 lzma libsoup ];

  meta = with stdenv.lib; {
    description = "Tools for managing the osinfo database";
    homepage = https://libosinfo.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
