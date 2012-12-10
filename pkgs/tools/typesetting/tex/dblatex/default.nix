{ stdenv, fetchurl, python, libxslt, tetex }:

stdenv.mkDerivation rec {
  name = "dblatex-0.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/dblatex/${name}.tar.bz2";
    sha256 = "120w3wm07qx0k1grgdhjwm2vpwil71icshjvqznskp1f6ggch290";
  };

  buildPhase = "true";
  
  installPhase = ''
    sed -i 's|self.install_layout == "deb"|False|' setup.py
    python ./setup.py install --prefix=$out
  '';

  buildInputs = [ python libxslt tetex ];

  meta = {
    description = "A program to convert DocBook to DVI, PostScript or PDF via LaTeX or ConTeXt";
    homepage = http://dblatex.sourceforge.net/;
    license = "GPL";
  };
}
