{ stdenv, fetchurl, pkgconfig, meson, ninja, gettext, glib, libxml2, perl, python3
, libxslt, libarchive, bzip2, lzma, json-glib, libsoup
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db-tools";
  version = "1.7.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "08x8mrafphyll0d35xdc143rip3ahrz6bmzhc85nwhq7yk2vxpab";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext perl python3 ];
  buildInputs = [ glib json-glib libxml2 libxslt libarchive bzip2 lzma libsoup ];

  meta = with stdenv.lib; {
    description = "Tools for managing the osinfo database";
    homepage = "https://libosinfo.org/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
