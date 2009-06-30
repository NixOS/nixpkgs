{stdenv, fetchurl, python, libxslt, tetex}:

stdenv.mkDerivation rec {
  name = "dblatex-0.2.8";
  
  src = fetchurl {
    url = "mirror://sourceforge/dblatex/${name}.tar.bz2";
    sha256 = "00slxwd1z9sajpxjvrqqgl3fnf9hwh17shg66pg2k2mnbgagxyr0";
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
