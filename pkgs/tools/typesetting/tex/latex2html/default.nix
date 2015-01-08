{ stdenv, fetchurl, tex, perl, netpbm, ghostscript }:

stdenv.mkDerivation rec {
  name = "latex2html-2008";

  src = fetchurl {
    url = "http://www.latex2html.org/~latex2ht/current/${name}.tar.gz";
    sha256 = "1b9pld6wz01p1pf5qwxjipdkhq34hmmw9mfkjp150hlqlcanhiar";
  };

  buildInputs = [ tex perl ghostscript netpbm ];

  preConfigure = ''
    patchShebangs .
    sed -i -e "s|#! /bin/cat|#! $(type -p cat)|" configure
    configureFlags="--with-texpath=$out/share/texmf-nix";
  '';

  meta = {
    homepage = "http://www.latex2html.org/";
    description = "Converter written in Perl that converts LaTeX documents to HTML";
    license = stdenv.lib.licenses.gpl2Plus;
  };

}
