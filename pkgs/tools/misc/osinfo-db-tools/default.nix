{ lib, stdenv, fetchurl, pkg-config, meson, ninja, gettext, glib, libxml2, perl, python3
, libxslt, libarchive, bzip2, xz, json-glib, libsoup
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db-tools";
  version = "1.9.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "sha256-JV8ch4us7HDDAg/1qcsPa9hhygAJ8kYI31729i1SQ8A=";
  };

  nativeBuildInputs = [ meson ninja pkg-config gettext perl python3 ];
  buildInputs = [ glib json-glib libxml2 libxslt libarchive bzip2 xz libsoup ];

  meta = with lib; {
    description = "Tools for managing the osinfo database";
    homepage = "https://libosinfo.org/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
