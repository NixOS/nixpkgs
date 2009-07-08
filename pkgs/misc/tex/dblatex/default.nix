{stdenv, fetchurl, python, libxslt, tetex}:

stdenv.mkDerivation rec {
  name = "dblatex-0.2.11";
  
  src = fetchurl {
    url = "mirror://sourceforge/dblatex/${name}.tar.bz2";
    sha256 = "cc1bd2c1aca5f6d03ef8516437321f75eba604d2067efe65f2d07815f56f7205";
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
