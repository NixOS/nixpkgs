{ stdenv, fetchurl, pkgconfig, meson, ninja, gettext, glib, libxml2, perl, python3
, libxslt, libarchive, bzip2, lzma, json-glib, libsoup
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db-tools";
  version = "1.8.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "038q3gzdbkfkhpicj0755mw1q4gbvn57pslpw8n2dp3lds9im0g9";
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
