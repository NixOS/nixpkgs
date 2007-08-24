{stdenv, fetchurl, tetex}:

stdenv.mkDerivation {
  name = "lazylist-1.0a";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.iai.uni-bonn.de/~loeh/lhs2tex/lazylist-1.0a.tar.bz2;
    md5 = "8ef357df5845bd8d6075fca6e1f214ab";
  };

  buildInputs = [tetex];

  inherit tetex;
}
