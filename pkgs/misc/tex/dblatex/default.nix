{stdenv, fetchurl, python, libxslt, tetex}:

stdenv.mkDerivation {
  name = "dblatex-0.2.7";
  
  src = fetchurl {
    url = mirror://sourceforge/dblatex/dblatex-0.2.7.tar.bz2;
    sha256 = "0wcsfr2arcayq10fp06h2l7zlbn7l4ffrvzc2qs86103q5xismmr";
  };

  buildPhase = "true";
  
  installPhase = "
    python ./setup.py install --prefix=$out
  ";

  buildInputs = [python libxslt tetex];

  meta = {
    description = "A program to convert DocBook to DVI, PostScript or PDF via LaTeX or ConTeXt";
    homepage = http://dblatex.sourceforge.net/;
    license = "GPL";
  };
}
