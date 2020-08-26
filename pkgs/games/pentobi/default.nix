{ stdenv, appstream, fetchurl, cmake, gettext, libxslt, librsvg, itstool
  , qtbase, qtquickcontrols2, qtsvg, qttools, qtwebview, docbook_xsl
  , wrapQtAppsHook
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "18.1";
  pname = "pentobi";

  src = fetchurl {
    url = "mirror://sourceforge/pentobi/${pname}-${version}.tar.xz";
    sha256 = "1vfw61lk9z7dngncmx3fggy5ld7ksdk48dpwnsq2vl5fh3f71qbq";
  };

  nativeBuildInputs = [ cmake docbook_xsl wrapQtAppsHook ];
  buildInputs = [ appstream qtbase qtsvg qtquickcontrols2 qttools qtwebview itstool librsvg ];

  patchPhase = ''
    substituteInPlace pentobi_thumbnailer/CMakeLists.txt --replace "/manpages" "/share/xml/docbook-xsl/manpages/"
    substituteInPlace pentobi/unix/CMakeLists.txt --replace "/manpages" "/share/xml/docbook-xsl/manpages/"
    substituteInPlace pentobi/docbook/CMakeLists.txt --replace "/html" "/share/xml/docbook-xsl/html"
  '';

  cmakeFlags = [
    "-DCMAKE_VERBOSE_MAKEFILE=1"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}"
    "-DMETAINFO_ITS=${appstream}/share/gettext/its/metainfo.its"
  ];

  meta = {
    description = "A computer opponent for the board game Blokus";
    homepage = "https://pentobi.sourceforge.io";
    license = licenses.gpl3;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
