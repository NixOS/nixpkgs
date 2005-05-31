{stdenv, fetchurl, hevea, tetex, strategoxt, aterm, sdf}: 

stdenv.mkDerivation {
  name = "bibtex-tools-0.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cs.uu.nl/~visser/ftp/bibtex-tools-0.1.tar.gz;
    md5 = "8e3ce277100af6fceec23f5bed4aa9e8";
  };
  inherit aterm tetex hevea sdf strategoxt;
  buildInputs = [aterm sdf strategoxt hevea];
}
