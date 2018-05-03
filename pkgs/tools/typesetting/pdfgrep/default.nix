{ stdenv, fetchurl, pkgconfig, poppler, libgcrypt, pcre, asciidoc }:

stdenv.mkDerivation rec {
  name = "pdfgrep-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "https://pdfgrep.org/download/${name}.tar.gz";
    sha256 = "13al23c2wlpsha6c1z1h6gh5lxzphsnzpd7b78qj16rq2r46phf9";
  };

  postPatch = ''
    for i in ./src/search.h ./src/pdfgrep.cc ./src/search.cc; do
      substituteInPlace $i --replace '<cpp/' '<'
    done
  '';

  nativeBuildInputs = [ pkgconfig asciidoc ];
  buildInputs = [ poppler libgcrypt pcre ];

  meta = {
    description = "Commandline utility to search text in PDF files";
    homepage = https://pdfgrep.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ qknight fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
