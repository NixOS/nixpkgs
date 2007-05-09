{stdenv, fetchurl, ghc}:

stdenv.mkDerivation {
  name = "frown-0.6.1";
  src = fetchurl {
    url = http://www.informatik.uni-bonn.de/~ralf/frown/frown-0.6.1.tar.gz;
    md5 = "b6fe9a8bf029c2a7c31b574be05816cf";
  };
  builder = ./builder.sh;
  buildInputs = [ghc];
}
