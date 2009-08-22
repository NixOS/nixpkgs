{stdenv, fetchurl, python, libxslt, tetex}:

stdenv.mkDerivation rec {
  name = "dblatex-0.2.12";

  src = fetchurl {
    url = "mirror://sourceforge/dblatex/${name}.tar.bz2";
    sha256 = "1wjghrlcn7hkr70nnyzzag1z57l5b1ck8i3r8zl7bw2rsrvqmyz2";
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
