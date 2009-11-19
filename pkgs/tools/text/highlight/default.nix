{ stdenv, fetchurl, getopt }:
        
stdenv.mkDerivation rec {
  name = "highlight-2.6.10";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/${name}.tar.bz2";
    sha256 = "18f2ki9pajxlp0aq4ingxj7m0cp7wlbc40xm25pnxc1yis9vlira";
  };

  buildInputs = [getopt];

  makeFlags = ["PREFIX=$out"];

  meta = {
    description = "Source code highlighting tool";
  };
}
