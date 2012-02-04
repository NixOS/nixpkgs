{ stdenv, fetchurl, python, libxslt, tetex }:

stdenv.mkDerivation rec {
  name = "dblatex-0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/dblatex/${name}.tar.bz2";
    sha256 = "0jg2acv2lyrbw06l8rr0id75lj1pws7xbsmryq58r3n13xzb1p7b";
  };

  buildPhase = "true";
  
  installPhase = "python ./setup.py install --prefix=$out";

  buildInputs = [ python libxslt tetex ];

  meta = {
    description = "A program to convert DocBook to DVI, PostScript or PDF via LaTeX or ConTeXt";
    homepage = http://dblatex.sourceforge.net/;
    license = "GPL";
  };
}
