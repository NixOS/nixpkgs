{stdenv, fetchurl, mesa, wxGTK}:

stdenv.mkDerivation {
  name = "mcrl2-200901";
  src = fetchurl {
    url = http://www.win.tue.nl/mcrl2/download/release/mcrl2-200901-src.tar.bz2 ;
    sha256 = "0lji31d7dv15q8092b8g01j023dd7miq3nw8klgc8jd136xpwdp9";
  };

  buildInputs = [ mesa wxGTK ] ;
}



