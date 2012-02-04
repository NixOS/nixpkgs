{stdenv, fetchurl, tex, perl, netpbm, ghostscript}:

stdenv.mkDerivation {
  name = "latex2html-2002-1";
  
  buildInputs = [ tex perl ghostscript netpbm ];

  preConfigure = ''
      configureFlags="--with-texpath=$out/share/texmf-nix";
  '';

  src = fetchurl {
    url = mirror://ubuntu/pool/multiverse/l/latex2html/latex2html_2002-2-1-20050114.orig.tar.gz;
    sha256 = "22049a77cf88a647776e61e06800ace4f9a06afc6ffe2590574487f023d0881f";
  };

  meta = {
    homepage = http://www.latex2html.org/;
    license = "unfree-redistributable";
    description = "Convertor written in Perl that converts LaTeX documents to HTML";
  };

}
