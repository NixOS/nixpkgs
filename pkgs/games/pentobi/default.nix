{ lib, mkDerivation, appstream, fetchFromGitHub, cmake, gettext, libxslt, librsvg, itstool
, qtbase, qtquickcontrols2, qtsvg, qttools, qtwebview, docbook_xsl
}:

mkDerivation rec {
  version = "18.5";
  pname = "pentobi";

  src = fetchFromGitHub {
    owner = "enz";
    repo = "pentobi";
    rev = "v${version}";
    sha256 = "sha256-iVgG2Ee1nJWpuquX2ntFHAJrPA0u9YnutmOC+cMrgZg=";
  };

  nativeBuildInputs = [ cmake docbook_xsl qttools ];
  buildInputs = [ appstream qtbase qtsvg qtquickcontrols2 qtwebview itstool librsvg ];

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

  meta = with lib; {
    description = "A computer opponent for the board game Blokus";
    homepage = "https://pentobi.sourceforge.io";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
