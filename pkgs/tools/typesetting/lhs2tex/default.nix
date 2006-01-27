{stdenv, fetchurl, tetex, polytable, ghc}:

assert tetex == polytable.tetex;

stdenv.mkDerivation {
  name = "lhs2tex-1.10pre";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.iai.uni-bonn.de/~loeh/lhs2tex/lhs2tex-1.10pre.tar.bz2;
    md5 = "4fb875cdc0ba8daacc18b97f76aab4bf";
  };

  buildInputs = [tetex ghc];
  propagatedBuildInputs = [polytable];

  inherit tetex;
}

