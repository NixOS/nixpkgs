{stdenv, fetchurl, tetex, polytable, ghc}:

assert tetex == polytable.tetex;

stdenv.mkDerivation {
  name = "lhs2tex-1.11";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.informatik.uni-bonn.de/~loeh/lhs2tex/lhs2tex-1.11.tar.bz2;
    md5 = "16fb6a150bc1ab5e22c66f52f11cec54";
  };

  buildInputs = [tetex ghc];
  propagatedBuildInputs = [polytable];

  inherit tetex;
}

