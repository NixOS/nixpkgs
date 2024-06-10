{ lib, mkDerivation, appstream, fetchFromGitHub, cmake, gettext, libxslt, librsvg, itstool
, qtbase, qtquickcontrols2, qtsvg, qttools, qtwebview, docbook_xsl
}:

mkDerivation rec {
  version = "20.0";
  pname = "pentobi";

  src = fetchFromGitHub {
    owner = "enz";
    repo = "pentobi";
    rev = "v${version}";
    sha256 = "sha256-DQM3IJ0pRkX4OsrjZGROg50LfKb621UnpvtqSjxchz8=";
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
    description = "Computer opponent for the board game Blokus";
    homepage = "https://pentobi.sourceforge.io";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
