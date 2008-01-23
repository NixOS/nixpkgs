{stdenv, fetchurl, tetex, polytable, ghc}:

assert tetex == polytable.tetex;

stdenv.mkDerivation {
  name = "lhs2tex-1.13pre3";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://www.cs.uu.nl/~andres/lhs2tex/lhs2tex-1.13pre3.tar.bz2";
    sha256 = "8ddc9bd150c20c33518d747fee95577ec8f587146532cda12b8034adc847826c";
  };

  buildInputs = [tetex ghc];
  propagatedBuildInputs = [polytable];
  propagatedUserEnvPackages = [polytable];

  inherit tetex;
}

