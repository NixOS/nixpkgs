{stdenv, fetchurl, tetex, polytable, ghc}:

assert tetex == polytable.tetex;

stdenv.mkDerivation {
  name = "lhs2tex-1.12";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.informatik.uni-bonn.de/~loeh/lhs2tex/lhs2tex-1.12.tar.bz2;
    md5 = "1bc982e96f19201aaf1c39c1d4b5e358";
  };

  buildInputs = [tetex ghc];
  propagatedBuildInputs = [polytable];
  propagatedUserEnvPackages = [polytable];

  inherit tetex;
}

