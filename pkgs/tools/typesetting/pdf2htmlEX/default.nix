{ stdenv, fetchFromGitHub, cmake, pkgconfig
, poppler, xlibs, pcre, python, glib, fontforge, cairo, pango, openjdk8

}:

stdenv.mkDerivation rec {
  name = "pdf2htmlEX-0.14.6";

  src = fetchFromGitHub {
    repo   = "pdf2htmlEX";
    owner  = "coolwanglu";
    rev    = "v0.14.6";
    sha256 = "1nh0ab8f11fsyi4ldknlkmdzcfvm1dfh8b9bmprjgq6q0vjj7f78";
  };

  patches = [ ./add-glib-cmake.patch ];

  cmakeFlags = [ "-DENABLE_SVG=ON" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    xlibs.libpthreadstubs
    xlibs.libXdmcp
    pcre
    python
    glib
    cairo
    pango
    poppler
    fontforge
    openjdk8
  ];

  meta = with stdenv.lib; {
    description = "Render PDF files to beautiful HTML";
    homepage    = "https://github.com/coolwanglu/pdf2htmlEX";
    license     = licenses.gpl3Plus;
    maintainers = [ maintainers.taktoa ];
    platforms   = with platforms; linux;
  };
}
