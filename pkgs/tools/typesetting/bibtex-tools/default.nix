{stdenv, fetchurl, hevea, strategoxt, aterm, sdf}: 

stdenv.mkDerivation {
  name = "bibtex-tools-0.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cs.uu.nl/~visser/ftp/bibtex-tools-0.1.tar.gz;
    md5 = "8e3ce277100af6fceec23f5bed4aa9e8";
  };
  inherit aterm hevea strategoxt;
  inherit (sdf) sglr pgen ptsupport asflibrary;
  buildInputs = [aterm sdf.pgen strategoxt hevea];
}
