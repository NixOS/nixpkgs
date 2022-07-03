{ lib
, stdenv
, fetchurl
, pkg-config
, meson
, ninja
, gettext
, glib
, libxml2
, perl
, python3
, libxslt
, libarchive
, bzip2
, xz
, json-glib
, libsoup_3
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db-tools";
  version = "1.10.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "sha256-gCzdU7QWcG6lhE8Ebdz7ZYwbSQa5+UDHmserxQmBymg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    perl
    python3
  ];

  buildInputs = [
    glib
    json-glib
    libxml2
    libxslt
    libarchive
    bzip2
    xz
    libsoup_3
  ];

  meta = with lib; {
    description = "Tools for managing the osinfo database";
    homepage = "https://libosinfo.org/";
    changelog = "https://gitlab.com/libosinfo/osinfo-db-tools/-/blob/v${version}/NEWS";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
